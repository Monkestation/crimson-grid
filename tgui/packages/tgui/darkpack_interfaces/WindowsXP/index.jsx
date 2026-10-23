import { useLayoutEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Flex, Icon } from 'tgui-core/components';
import { resolveAsset } from '../../assets';
import { AdwarePopups } from './PcAdwarePopups';
import { PcBankManager } from './PcBankManager';
import { PcBookReader } from './PcBookReader';
import { PcBountyBoard } from './PcBountyBoard';
import { PcCdBurner } from './PcCdBurner';
import { PcCheckout } from './PcCheckout';
import { PcEmail } from './PcEmail';
import { PcGeocities } from './PcGeocities';
import { PcHacking } from './PcHacking';
import { PcImageBoard } from './PcImageBoard';
import { PcLibrary } from './PcLibrary';
import { PcMediaPlayer } from './PcMediaPlayer';
import { PcMinesweeper } from './PcMinesweeper';
import { PcNetworkAutomation } from './PcNetworkAutomation';
import { PcNetworkBrowser } from './PcNetworkBrowser';
import { PcNetworkLog } from './PcNetworkLog';
import { PcNightcrawler } from './PcNightcrawler';
import { PcNightcrawlerEditor } from './PcNightcrawlerEditor';
import { PcNotepad } from './PcNotepad';
import { PcPaint } from './PcPaint';
import { PcPermissions } from './PcPermissions';
import { PcPortraitPrinter } from './PcPortraitPicker';
import { PcRecords } from './PcRecords';
import { PcSecurityCamera } from './PcSecurityCamera';
import { PcSolitaire } from './PcSolitaire';
import { PcSupply } from './PcSupply';

//note this uses style = {} because I am not a chud.
//this is unfortunately required since we are using windows and not new ui
const PROGRAM_COMPONENTS = {
  PcBankManager,
  PcEmail,
  PcRecords,
  PcSupply,
  PcNetworkBrowser,
  PcNotepad,
  PcPermissions,
  PcSecurityCamera,
  PcImageBoard,
  PcPaint,
  PcGeocities,
  PcBountyBoard,
  PcNetworkAutomation,
  PcBookReader,
  PcLibrary,
  PcPortraitPrinter,
  PcCheckout,
  PcNightcrawler,
  PcNightcrawlerEditor,
  PcNetworkLog,
  PcSolitaire,
  PcMinesweeper,
  PcHacking,
  PcMediaPlayer,
  PcCdBurner,
};

const XP = {
  titleActive:
    'linear-gradient(180deg, #0997ff 0%, #0058ee 8%, #0050ee 40%, #0066ff 88%, #0050d4 100%)',
  titleInactive:
    'linear-gradient(180deg, #7a9bd6 0%, #6483c4 8%, #5f7fc0 40%, #7090cf 88%, #5a78b8 100%)',
  windowFace: '#ece9d8',
  windowBorder: '#0055ea',
  windowBorderInactive: '#6483c4',
  desktopFallback:
    'linear-gradient(180deg, #245edb 0%, #3a6ea5 40%, #5b9bd5 75%, #87b8e8 100%)',
  taskbar: 'linear-gradient(180deg, #3168d5 0%, #245edb 30%, #1941a5 100%)',
  start: 'linear-gradient(180deg, #5cb85c 0%, #3d8b3d 45%, #2d6b2d 100%)',
  taskBtn: 'linear-gradient(180deg, #3a7aef 0%, #1e4db8 100%)',
  taskBtnActive: 'linear-gradient(180deg, #1a3a8a 0%, #0d2255 100%)',
  startMenuTop: 'linear-gradient(180deg, #1160d0 0%, #0a4cb8 100%)',
};

const ICONS_PER_ROW = 5;
const ICON_WIDTH = 76;
const WINDOW_WIDTH = 740;
const WINDOW_HEIGHT = 480;
const TITLEBAR_HEIGHT = 28;
const START_MENU_BODY_HEIGHT = 300;

const driveButtonStyle = {
  display: 'block',
  width: '100%',
  padding: '3px 6px',
  fontSize: 11,
  fontFamily: 'inherit',
  color: '#000',
  background: '#ece9d8',
  border: '1px solid #7f9db9',
  borderRadius: 2,
  cursor: 'pointer',
};

//! this might no longer be needed since I use useState() now
let startIgnoreUntil = 0;

export const WindowsXP = (props, context) => {
  const { act, data = {} } = useBackend(context);
  const programs = data.programs || [];
  const floppy = data.floppy;

  const [positions, setPositions] = useState({});
  const [stack, setStack] = useState([]);
  const [startOpen, setStartOpen] = useState(false);
  const [startSearch, setStartSearch] = useState('');
  const desktopRef = useRef(null);
  const startMenuRef = useRef(null);
  // Start menu rectangle in desktop coordinates
  const [startRect, setStartRect] = useState(null);

  useLayoutEffect(() => {
    const desktop = desktopRef.current;
    const menu = startMenuRef.current;
    if (!startOpen || !desktop || !menu) {
      setStartRect(null);
      return;
    }
    const d = desktop.getBoundingClientRect();
    const m = menu.getBoundingClientRect();
    setStartRect({
      x: m.left - d.left,
      y: m.top - d.top,
      w: m.width,
      h: m.height,
    });
  }, [startOpen, (data.programs || []).length, !!floppy]);

  const openPrograms = programs
    .filter((p) => p.open)
    .sort((a, b) => stack.indexOf(a.id) - stack.indexOf(b.id));
  const activeId = openPrograms.length
    ? openPrograms[openPrograms.length - 1].id
    : null;

  // Start menu list, filtered by the search box
  const searchQuery = startSearch.trim().toLowerCase();
  const filteredPrograms = searchQuery
    ? programs.filter((p) => (p.name || '').toLowerCase().includes(searchQuery))
    : programs;

  // Current position of a window (dragged position, or the cascade default)
  const getPos = (prog, i) =>
    positions[prog.id] || {
      x: 100 + i * 18,
      y: 28 + i * 22,
    };

  const focusProgram = (id) => {
    setStack((prev) =>
      prev[prev.length - 1] === id
        ? prev
        : [...prev.filter((x) => x !== id), id],
    );
  };

  const closeStartMenu = () => {
    startIgnoreUntil = Date.now() + 500;
    setStartOpen(false);
    setStartSearch('');
  };

  const openProgram = (id) => {
    closeStartMenu();
    focusProgram(id);
    act('open_program', { id });
  };

  const startDrag = (e, id) => {
    if (e.button !== undefined && e.button !== 0) {
      return;
    }
    e.preventDefault();
    focusProgram(id);

    const desktop = desktopRef.current;
    const winEl = e.currentTarget.parentElement;
    if (!desktop || !winEl) {
      return;
    }
    const deskRect = desktop.getBoundingClientRect();
    const winRect = winEl.getBoundingClientRect();
    const offsetX = e.clientX - winRect.left;
    const offsetY = e.clientY - winRect.top;

    const onMove = (ev) => {
      const maxX = deskRect.width - 80;
      const maxY = deskRect.height - TITLEBAR_HEIGHT;
      let x = ev.clientX - deskRect.left - offsetX;
      let y = ev.clientY - deskRect.top - offsetY;
      x = Math.max(80 - WINDOW_WIDTH, Math.min(maxX, x));
      y = Math.max(0, Math.min(maxY, y));
      setPositions((prev) => ({ ...prev, [id]: { x, y } }));
    };
    const onUp = () => {
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  };

  const renderBody = (prog, i) => {
    const Component = PROGRAM_COMPONENTS[prog.tgui_id];
    if (!Component) {
      return (
        <Box p={2} style={{ color: '#000' }}>
          Unknown Program: {prog.tgui_id || prog.id}
        </Box>
      );
    }
    // Native BYOND controls can't be layered under DOM elements, so give the
    // program the rectangles (desktop coordinates) of everything drawn above
    // it. The program decides whether its native control is actually hit.
    const coverRects = openPrograms.slice(i + 1).map((other, j) => {
      const p = getPos(other, i + 1 + j);
      return { x: p.x, y: p.y, w: WINDOW_WIDTH, h: WINDOW_HEIGHT };
    });
    if (startRect) {
      coverRects.push(startRect);
    }
    return (
      <Component
        programId={prog.id}
        desktopRef={desktopRef}
        coverRects={coverRects}
      />
    );
  };

  return (
    <Window
      title={data.is_schrecknet ? 'SchreckNet' : 'Windows XP Professional'}
      width={980}
      height={660}
    >
      <Window.Content fitted>
        <Box
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
            width: '100%',
            fontFamily: 'Tahoma, "Segoe UI", sans-serif',
            fontSize: '11px',
          }}
        >
          <div
            ref={desktopRef}
            style={{
              flex: '1 1 auto',
              position: 'relative',
              overflow: 'hidden',
              minHeight: 0,
              background: XP.desktopFallback,
              backgroundImage: `url("${resolveAsset('xp_bliss.jpg')}")`,
              backgroundSize: 'cover',
              backgroundPosition: 'center',
            }}
          >
            <Box
              style={{
                position: 'absolute',
                top: 16,
                left: 14,
                zIndex: 1,
                display: 'grid',
                gridTemplateColumns: `repeat(${ICONS_PER_ROW}, ${ICON_WIDTH}px)`,
                gap: '8px 6px',
              }}
            >
              {programs.map((prog) => (
                <Box
                  key={prog.id}
                  style={{
                    width: ICON_WIDTH,
                    textAlign: 'center',
                    color: '#fff',
                    textShadow: '1px 1px 2px rgba(0,0,0,0.9)',
                    cursor: 'pointer',
                    userSelect: 'none',
                    padding: '4px 2px',
                  }}
                  onClick={() => openProgram(prog.id)}
                >
                  <Box
                    style={{
                      width: 48,
                      height: 48,
                      margin: '0 auto 4px',
                      background: 'rgba(255,255,255,0.15)',
                      borderRadius: 4,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      border: '1px solid rgba(255,255,255,0.3)',
                    }}
                  >
                    <Icon name={prog.icon || 'window-maximize'} size={2} />
                  </Box>
                  <Box style={{ fontSize: 11, lineHeight: 1.2 }}>
                    {prog.name}
                  </Box>
                </Box>
              ))}

              {floppy && (
                <Box
                  key="floppy_drive"
                  style={{
                    width: ICON_WIDTH,
                    textAlign: 'center',
                    color: '#fff',
                    textShadow: '1px 1px 2px rgba(0,0,0,0.9)',
                    cursor: 'pointer',
                    userSelect: 'none',
                    padding: '4px 2px',
                  }}
                  onClick={() => setStartOpen(true)}
                >
                  <Box
                    style={{
                      width: 48,
                      height: 48,
                      margin: '0 auto 4px',
                      background: 'rgba(255,255,255,0.15)',
                      borderRadius: 4,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      border: '1px solid rgba(255,255,255,0.3)',
                    }}
                  >
                    <Icon name="save" size={2} />
                  </Box>
                  <Box style={{ fontSize: 11, lineHeight: 1.2 }}>
                    Floppy (A:)
                  </Box>
                </Box>
              )}
            </Box>

            {openPrograms.map((prog, i) => {
              const isActive = prog.id === activeId;
              const pos = getPos(prog, i);
              return (
                <Box
                  key={prog.id}
                  onMouseDown={() => focusProgram(prog.id)}
                  style={{
                    position: 'absolute',
                    top: pos.y,
                    left: pos.x,
                    width: WINDOW_WIDTH,
                    height: WINDOW_HEIGHT,
                    zIndex: 10 + i,
                    display: 'flex',
                    flexDirection: 'column',
                    background: XP.windowFace,
                    border: `2px solid ${
                      isActive ? XP.windowBorder : XP.windowBorderInactive
                    }`,
                    borderRadius: '6px 6px 0 0',
                    boxShadow: isActive
                      ? '4px 4px 14px rgba(0,0,0,0.5)'
                      : '2px 2px 8px rgba(0,0,0,0.35)',
                  }}
                >
                  <Flex
                    align="center"
                    onMouseDown={(e) => startDrag(e, prog.id)}
                    style={{
                      flex: `0 0 ${TITLEBAR_HEIGHT}px`,
                      background: isActive ? XP.titleActive : XP.titleInactive,
                      color: '#fff',
                      padding: '0 4px 0 8px',
                      fontWeight: 'bold',
                      fontSize: 12,
                      textShadow: '1px 1px 1px rgba(0,0,0,0.4)',
                      borderRadius: '4px 4px 0 0',
                      cursor: 'move',
                      userSelect: 'none',
                    }}
                  >
                    <Flex.Item grow={1}>
                      <Icon name={prog.icon || 'window-maximize'} mr={1} />
                      {prog.name}
                    </Flex.Item>
                    <Flex.Item>
                      <Box
                        as="button"
                        onMouseDown={(e) => e.stopPropagation()}
                        onClick={() => act('close_program', { id: prog.id })}
                        style={{
                          width: 22,
                          height: 22,
                          border: '1px solid rgba(255,255,255,0.7)',
                          borderRadius: 3,
                          background:
                            'linear-gradient(180deg, #f07a6e 0%, #e04343 50%, #c62828 100%)',
                          color: '#fff',
                          fontWeight: 'bold',
                          cursor: 'pointer',
                          lineHeight: '20px',
                          textAlign: 'center',
                          padding: 0,
                        }}
                      >
                        ✕
                      </Box>
                    </Flex.Item>
                  </Flex>
                  <Box
                    style={{
                      flex: '1 1 auto',
                      minHeight: 0,
                      margin: 3,
                      background: '#fff',
                      border: '1px solid #aca899',
                      overflow: 'auto',
                      color: '#000',
                    }}
                  >
                    {renderBody(prog, i)}
                  </Box>
                </Box>
              );
            })}

            {startOpen && (
              <>
                <Box
                  style={{
                    position: 'absolute',
                    inset: 0,
                    zIndex: 35,
                    background: 'transparent',
                  }}
                  onMouseDown={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    closeStartMenu();
                  }}
                />
                <div
                  ref={startMenuRef}
                  style={{
                    position: 'absolute',
                    left: 0,
                    bottom: 0,
                    width: 380,
                    zIndex: 40,
                    display: 'flex',
                    flexDirection: 'column',
                    boxShadow: '4px 0 16px rgba(0,0,0,0.45)',
                    border: '1px solid #003399',
                    borderBottom: 'none',
                  }}
                  onMouseDown={(e) => e.stopPropagation()}
                >
                  <Box
                    style={{
                      background: XP.startMenuTop,
                      color: '#fff',
                      padding: '10px 12px',
                      display: 'flex',
                      alignItems: 'center',
                      gap: 10,
                      fontWeight: 'bold',
                      fontSize: 14,
                      textShadow: '1px 1px 1px rgba(0,0,0,0.4)',
                    }}
                  >
                    <Box
                      style={{
                        width: 42,
                        height: 42,
                        borderRadius: 4,
                        background: 'rgba(255,255,255,0.25)',
                        border: '2px solid rgba(255,255,255,0.6)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                      }}
                    >
                      <Icon name="user" size={1.6} />
                    </Box>
                    {data.login_name || 'Guest'}
                  </Box>

                  <Box
                    style={{
                      display: 'flex',
                      height: START_MENU_BODY_HEIGHT,
                      background: '#fff',
                    }}
                  >
                    <Box
                      style={{
                        flex: 1,
                        minWidth: 0,
                        display: 'flex',
                        flexDirection: 'column',
                        background: '#ffffff',
                        borderRight: '1px solid #b8b8b8',
                        color: '#000000',
                      }}
                    >
                      <Box
                        style={{
                          flex: '0 0 auto',
                          padding: '6px 8px',
                          borderBottom: '1px solid #d4d0c8',
                        }}
                      >
                        <input
                          autoFocus
                          type="text"
                          value={startSearch}
                          placeholder="Search programs..."
                          onChange={(e) => setStartSearch(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter' && filteredPrograms.length) {
                              openProgram(filteredPrograms[0].id);
                            } else if (e.key === 'Escape') {
                              closeStartMenu();
                            }
                          }}
                          style={{
                            width: '100%',
                            boxSizing: 'border-box',
                            padding: '3px 6px',
                            fontSize: 12,
                            fontFamily: 'inherit',
                            color: '#000',
                            background: '#fff',
                            border: '1px solid #7f9db9',
                            outline: 'none',
                          }}
                        />
                      </Box>
                      <Box
                        style={{
                          flex: '1 1 auto',
                          minHeight: 0,
                          overflowY: 'auto',
                          padding: '4px 0',
                        }}
                      >
                        {filteredPrograms.length === 0 && (
                          <Box
                            style={{
                              padding: '8px 12px',
                              color: '#888',
                              fontSize: 12,
                            }}
                          >
                            No programs found.
                          </Box>
                        )}
                        {filteredPrograms.map((prog) => (
                          <Box
                            key={prog.id}
                            style={{
                              display: 'flex',
                              alignItems: 'center',
                              gap: 10,
                              padding: '7px 12px',
                              cursor: 'pointer',
                              fontSize: 12,
                              color: '#000000',
                            }}
                            onMouseEnter={(e) => {
                              e.currentTarget.style.background = '#316ac5';
                              e.currentTarget.style.color = '#ffffff';
                            }}
                            onMouseLeave={(e) => {
                              e.currentTarget.style.background = 'transparent';
                              e.currentTarget.style.color = '#000000';
                            }}
                            onMouseDown={(e) => {
                              e.preventDefault();
                              e.stopPropagation();
                              openProgram(prog.id);
                            }}
                          >
                            <Icon
                              name={prog.icon || 'window-maximize'}
                              style={{ color: 'inherit' }}
                            />
                            <Box
                              style={{
                                color: 'inherit',
                                fontWeight: prog.open ? 700 : 400,
                                whiteSpace: 'nowrap',
                                overflow: 'hidden',
                                textOverflow: 'ellipsis',
                              }}
                            >
                              {prog.name}
                            </Box>
                          </Box>
                        ))}
                      </Box>
                    </Box>

                    <Box
                      style={{
                        width: 150,
                        background: '#d3e5fa',
                        padding: '8px 0',
                        fontSize: 11,
                        color: '#000000',
                        overflowY: 'auto',
                      }}
                    >
                      <Box
                        style={{
                          padding: '8px 12px',
                          cursor: 'pointer',
                          color: '#000000',
                        }}
                        onMouseDown={(e) => {
                          e.preventDefault();
                          e.stopPropagation();
                          closeStartMenu();
                          act('logout');
                        }}
                      >
                        <Icon name="sign-out-alt" mr={1} />
                        Log Off
                      </Box>
                      <Box
                        style={{
                          padding: '8px 12px',
                          color: '#000000',
                          borderTop: '1px solid #b8b8b8',
                        }}
                      >
                        <Box fontWeight="bold" mb={0.5}>
                          <Icon name="network-wired" mr={1} />
                          Network: {data.network_name || 'Local'}
                        </Box>
                        {Array.isArray(data.available_networks) &&
                          data.available_networks.map((net) => (
                            <Box
                              key={net.id}
                              style={{
                                padding: '4px 8px',
                                marginTop: 2,
                                cursor: net.allowed ? 'pointer' : 'not-allowed',
                                background:
                                  data.network_id === net.id
                                    ? '#316ac5'
                                    : 'transparent',
                                color:
                                  data.network_id === net.id
                                    ? '#fff'
                                    : net.allowed
                                      ? '#000'
                                      : '#888',
                                borderRadius: 2,
                                opacity: net.allowed ? 1 : 0.6,
                              }}
                              onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                if (net.allowed && data.network_id !== net.id) {
                                  closeStartMenu();
                                  act('switch_network', { network_id: net.id });
                                }
                              }}
                            >
                              {net.name} {!net.allowed ? '(Locked)' : ''}
                            </Box>
                          ))}
                      </Box>
                      <Box
                        style={{
                          padding: '8px 12px',
                          color: '#000000',
                          borderTop: '1px solid #b8b8b8',
                        }}
                      >
                        <Box fontWeight="bold" mb={0.5}>
                          <Icon name="save" mr={1} />
                          Floppy Drive (A:)
                        </Box>
                        {floppy ? (
                          <>
                            <Box
                              style={{ fontSize: 11, wordBreak: 'break-word' }}
                            >
                              {floppy.name}
                            </Box>
                            <Box
                              style={{
                                fontSize: 11,
                                color: '#555',
                                marginBottom: 4,
                              }}
                            >
                              {floppy.program
                                ? `Contains: ${floppy.program}`
                                : 'Disk is blank'}
                            </Box>
                            {floppy.program && (
                              <Box
                                as="button"
                                disabled={floppy.installed}
                                style={{
                                  ...driveButtonStyle,
                                  marginBottom: 3,
                                  color: floppy.installed ? '#888' : '#000',
                                  cursor: floppy.installed
                                    ? 'not-allowed'
                                    : 'pointer',
                                }}
                                onMouseDown={(e) => {
                                  e.preventDefault();
                                  e.stopPropagation();
                                  if (floppy.installed) {
                                    return;
                                  }
                                  closeStartMenu();
                                  act('install_floppy');
                                }}
                              >
                                {floppy.installed
                                  ? 'Already installed'
                                  : 'Install'}
                              </Box>
                            )}
                            <Box
                              as="button"
                              style={driveButtonStyle}
                              onMouseDown={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                act('eject_floppy');
                              }}
                            >
                              Eject
                            </Box>
                          </>
                        ) : (
                          <Box style={{ fontSize: 11, color: '#888' }}>
                            No disk in drive.
                          </Box>
                        )}
                      </Box>
                      <Box style={{ padding: '8px 12px', color: '#333333' }}>
                        <Icon name="info-circle" mr={1} />
                        About PC
                      </Box>
                    </Box>
                  </Box>

                  <Box
                    style={{
                      background: '#245edb',
                      color: '#fff',
                      padding: '6px 10px',
                      fontSize: 11,
                      display: 'flex',
                      justifyContent: 'flex-end',
                    }}
                  >
                    <Box
                      as="button"
                      style={{
                        background: 'transparent',
                        border: 'none',
                        color: '#fff',
                        cursor: 'pointer',
                      }}
                      onMouseDown={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        closeStartMenu();
                        act('logout');
                      }}
                    >
                      <Icon name="sign-out-alt" mr={1} />
                      Log Off
                    </Box>
                  </Box>
                </div>
              </>
            )}
            {!!data.adware && <AdwarePopups desktopRef={desktopRef} />}
          </div>

          <Box
            style={{
              flex: '0 0 36px',
              display: 'flex',
              alignItems: 'center',
              padding: '0 3px',
              background: XP.taskbar,
              borderTop: '1px solid #5a9aef',
              position: 'relative',
              zIndex: 50,
            }}
          >
            <Box
              as="button"
              onClick={(e) => {
                e.stopPropagation();
                if (Date.now() < startIgnoreUntil) {
                  return;
                }
                if (startOpen) {
                  closeStartMenu();
                } else {
                  setStartOpen(true);
                }
              }}
              style={{
                height: 30,
                padding: '0 14px 0 8px',
                marginRight: 6,
                border: startOpen ? '1px solid #1a4a1a' : 'none',
                borderRadius: '0 16px 16px 0',
                background: XP.start,
                color: '#fff',
                fontWeight: 'bold',
                fontSize: 13,
                fontStyle: 'italic',
                textShadow: '1px 1px 1px rgba(0,0,0,0.5)',
                boxShadow: startOpen
                  ? 'inset 1px 1px 3px rgba(0,0,0,0.45)'
                  : 'inset 0 1px 0 rgba(255,255,255,0.35)',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: 6,
              }}
            >
              <Icon name="microsoft" />
              start
            </Box>

            <Box
              style={{
                width: 1,
                height: 24,
                background: 'rgba(0,0,0,0.35)',
                marginRight: 4,
                boxShadow: '1px 0 0 rgba(255,255,255,0.15)',
              }}
            />

            {openPrograms.map((prog) => {
              const active = prog.id === activeId;
              return (
                <Box
                  key={prog.id}
                  as="button"
                  onClick={() => openProgram(prog.id)}
                  style={{
                    height: 28,
                    minWidth: 140,
                    maxWidth: 180,
                    marginRight: 3,
                    padding: '0 10px',
                    border: active ? '1px solid #0a2060' : '1px solid #3a6ecc',
                    borderRadius: 3,
                    background: active ? XP.taskBtnActive : XP.taskBtn,
                    color: '#fff',
                    fontSize: 11,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 6,
                    boxShadow: active
                      ? 'inset 1px 1px 3px rgba(0,0,0,0.5)'
                      : 'inset 0 1px 0 rgba(255,255,255,0.2)',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                    whiteSpace: 'nowrap',
                  }}
                >
                  <Icon name={prog.icon || 'window-maximize'} />
                  {prog.name}
                </Box>
              );
            })}

            <Box
              style={{
                marginLeft: 'auto',
                height: 28,
                padding: '0 10px',
                display: 'flex',
                alignItems: 'center',
                gap: 8,
                background: 'rgba(0,0,0,0.2)',
                borderRadius: 3,
                border: '1px solid rgba(0,0,0,0.25)',
                color: '#fff',
                fontSize: 11,
              }}
            >
              {data.logged_in ? (
                <Box>
                  <Icon name="user" mr={1} />
                  {data.login_name}
                </Box>
              ) : (
                <Box opacity={0.7}>Not logged in</Box>
              )}
              <Box
                style={{ fontWeight: 'bold', minWidth: 64, textAlign: 'right' }}
              >
                {data.time}
              </Box>
            </Box>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
