import { useEffect, useRef, useState } from 'react';
import { Box } from 'tgui-core/components';

const POPUP_WIDTH = 250;
const POPUP_HEIGHT = 130;
const SPAWN_INTERVAL_MS = 2500;
const MAX_POPUPS = 10;

// Shown on every network except SchreckNet
const HUMAN_ADS = [
  {
    title: 'CONGRATULATIONS!!!',
    body: 'You are the 1,000,000th visitor! Click YES to claim your FREE prize!',
    yes: 'YES!!!',
  },
  {
    title: 'Hot Singles In Your Area',
    body: 'Local singles want to meet YOU tonight. Sign up free in 30 seconds!',
    yes: 'Meet Now',
  },
  {
    title: 'Your PC Is Infected!',
    body: 'Warning: 37 viruses detected. Download FreeScan Pro immediately.',
    yes: 'Scan Now',
  },
  {
    title: 'Cheap Meds Online',
    body: 'No prescription needed. Order now, discreet shipping worldwide.',
    yes: 'Order',
  },
  {
    title: 'You Won A Free Cruise',
    body: 'Spend 7 nights in the Bahamas. All you pay is a small handling fee!',
    yes: 'Claim',
  },
  {
    title: 'Make $$$ From Home',
    body: 'Local mom earns $5,000 a week. Doctors HATE her!',
    yes: 'Learn How',
  },
  {
    title: 'FREE Ringtones',
    body: 'Get 10 FREE polyphonic ringtones sent straight to your phone!',
    yes: 'Download',
  },
  {
    title: 'Refinance Today',
    body: 'Rates at an all time low. You may qualify for $0 down!',
    yes: 'Apply Now',
  },
];

// Shown only while connected to SchreckNet
const KINDRED_ADS = [
  {
    title: 'Hot Singles In Your Area',
    body: 'Local kindred want to meet YOU tonight. No blood bags required.',
    yes: 'Meet Now',
  },
  {
    title: 'Cheap Meds Online',
    body: 'Fangs too short? Sunburn? Order now, discreet shipping worldwide.',
    yes: 'Order',
  },
  {
    title: 'You Won A Free Cruise',
    body: 'Spend 7 nights on a fully windowless luxury cabin. Act now!',
    yes: 'Claim',
  },
  {
    title: 'Make $$$ From Home',
    body: 'Local ghoul earns $5,000 a week. Elders HATE him!',
    yes: 'Learn How',
  },
  {
    title: 'Your Haven Is Exposed!',
    body: 'Warning: 37 Masquerade breaches detected. Download HavenGuard now.',
    yes: 'Secure Now',
  },
  {
    title: 'Blood Doll Deals',
    body: 'Fresh, vetted, disease-free vessels delivered to your door. 2 for 1!',
    yes: 'Order Now',
  },
  {
    title: 'Sun Too Bright?',
    body: 'Try SunBlock Ultra. Walk the day with confidence. Side effects: ash.',
    yes: 'Buy Now',
  },
  {
    title: 'CONGRATULATIONS!!!',
    body: 'You are the 1,000,000th visitor! Claim your FREE Embrace!',
    yes: 'YES!!!',
  },
];

export const AdwarePopups = (props) => {
  const { desktopRef, schrecknet } = props;
  const [popups, setPopups] = useState([]);
  const nextId = useRef(1);
  const schrecknetRef = useRef(!!schrecknet);
  schrecknetRef.current = !!schrecknet;

  const makePopup = () => {
    const rect = desktopRef.current?.getBoundingClientRect();
    const width = rect?.width ?? 900;
    const height = rect?.height ?? 600;
    const ads = schrecknetRef.current ? KINDRED_ADS : HUMAN_ADS;
    return {
      id: nextId.current++,
      ad: ads[Math.floor(Math.random() * ads.length)],
      x: Math.floor(Math.random() * Math.max(1, width - POPUP_WIDTH)),
      y: Math.floor(Math.random() * Math.max(1, height - POPUP_HEIGHT)),
    };
  };

  const spawn = (count = 1) => {
    setPopups((prev) => {
      const next = [...prev];
      for (let i = 0; i < count && next.length < MAX_POPUPS; i++) {
        next.push(makePopup());
      }
      return next;
    });
  };

  useEffect(() => {
    spawn();
    const timer = setInterval(() => spawn(), SPAWN_INTERVAL_MS);
    return () => clearInterval(timer);
  }, []);

  useEffect(() => {
    setPopups([]);
  }, [!!schrecknet]);

  const close = (id) => {
    setPopups((prev) => prev.filter((p) => p.id !== id));
    if (Math.random() < 0.5) {
      spawn();
    }
  };

  const accept = (id) => {
    setPopups((prev) => prev.filter((p) => p.id !== id));
    spawn(2);
  };

  return (
    <>
      {popups.map((popup, i) => (
        <Box
          key={popup.id}
          onMouseDown={(e) => e.stopPropagation()}
          style={{
            position: 'absolute',
            left: popup.x,
            top: popup.y,
            width: POPUP_WIDTH,
            height: POPUP_HEIGHT,
            zIndex: 100 + i,
            display: 'flex',
            flexDirection: 'column',
            background: '#ece9d8',
            border: '2px solid #0055ea',
            borderRadius: '6px 6px 0 0',
            boxShadow: '4px 4px 14px rgba(0,0,0,0.5)',
            color: '#000',
          }}
        >
          <Box
            style={{
              flex: '0 0 22px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '0 3px 0 6px',
              background:
                'linear-gradient(180deg, #0997ff 0%, #0058ee 8%, #0050ee 40%, #0066ff 88%, #0050d4 100%)',
              color: '#fff',
              fontWeight: 'bold',
              fontSize: 11,
              borderRadius: '4px 4px 0 0',
              userSelect: 'none',
              whiteSpace: 'nowrap',
              overflow: 'hidden',
            }}
          >
            <span>{popup.ad.title}</span>
            <Box
              as="button"
              onClick={() => close(popup.id)}
              style={{
                width: 18,
                height: 18,
                padding: 0,
                lineHeight: '16px',
                border: '1px solid rgba(255,255,255,0.7)',
                borderRadius: 3,
                background:
                  'linear-gradient(180deg, #f07a6e 0%, #e04343 50%, #c62828 100%)',
                color: '#fff',
                fontWeight: 'bold',
                cursor: 'pointer',
              }}
            >
              ✕
            </Box>
          </Box>
          <Box
            style={{
              flex: '1 1 auto',
              padding: '8px 10px',
              fontSize: 11,
              background: '#fff',
              margin: 3,
              border: '1px solid #aca899',
            }}
          >
            {popup.ad.body}
          </Box>
          <Box style={{ padding: '0 6px 6px', textAlign: 'center' }}>
            <Box
              as="button"
              onClick={() => accept(popup.id)}
              style={{
                padding: '3px 14px',
                fontSize: 11,
                fontWeight: 'bold',
                color: '#000',
                background: '#ece9d8',
                border: '1px solid #7f9db9',
                borderRadius: 2,
                cursor: 'pointer',
              }}
            >
              {popup.ad.yes}
            </Box>
          </Box>
        </Box>
      ))}
    </>
  );
};
