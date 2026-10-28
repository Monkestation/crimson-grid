// THIS IS A DARKPACK UI FILE
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  creature: string;
  damage: string;
  blood: string;
  disease: string;
  mental: string;
};

const HANDWRITING: React.CSSProperties = {
  fontFamily: "'Segoe Script', 'Bradley Hand ITC', cursive",
  color: '#000000',
  fontSize: '13px',
  lineHeight: '1.3',
};

export function Valeren() {
  const { data } = useBackend<Data>();
  const { creature, damage, blood, disease, mental } = data;

  return (
    <Window width={512} height={750} title="Sense Vitality">
      <Window.Content fitted>
        <div
          style={{
            position: 'relative',
            width: '100%',
            height: '100%',
            overflow: 'hidden',
          }}
        >
          <img
            src={resolveAsset('da_vinci_vitruve_luc_viatour.webp')}
            style={{
              position: 'absolute',
              top: 0,
              left: '50%',
              transform: 'translateX(-50%)',
              height: '100%',
              pointerEvents: 'none',
              userSelect: 'none',
            }}
          />
          {creature && (
            <div style={{ ...HANDWRITING, position: 'absolute', top: '16%', left: 0, right: 0, textAlign: 'center' }}>
              {creature}
            </div>
          )}
          {damage && (
            <div style={{ ...HANDWRITING, position: 'absolute', top: '35%', left: '55%', right: '2%', textAlign: 'left' }}>
              {damage}
            </div>
          )}
          {blood && (
            <div style={{ ...HANDWRITING, position: 'absolute', top: '50%', left: '15%', width: '45%', textAlign: 'right' }}>
              {blood}
            </div>
          )}
          {disease && (
            <div style={{ ...HANDWRITING, position: 'absolute', top: '65%', left: '35%', right: '2%', textAlign: 'left' }}>
              {disease}
            </div>
          )}
          {mental && (
            <div style={{ ...HANDWRITING, position: 'absolute', top: '55%', left: '25%', right: '2%', width: '45%', textAlign: 'right' }}>
              {mental}
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
}
