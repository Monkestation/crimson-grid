// THIS IS A DARKPACK UI FILE
import { useState } from 'react';
import { Button, Slider, Stack } from 'tgui-core/components';
import type {
  FeatureNumeric,
  FeatureNumericData,
  FeatureValueProps,
} from '../base';

type HeightServerData = FeatureNumericData & {
  height_labels: Record<string, string>;
};
// on the back end, the height value 6 is around 4'10, which is 58 inches according to google so thats our baseline
const minimum_height = 58; // heights are integers on the back end, which sucks, but we cope by doing math on the front end i guess

function HeightInput(
  props: FeatureValueProps<number, number, HeightServerData>,
) {
  const { serverData, handleSetValue, value } = props;
  const min = serverData?.minimum ?? 6;
  const max = serverData?.maximum ?? 18;
  const serverStep = serverData?.step ?? 2; // increments of 2. theres only 7 'real' heights, or height values that change the sprite
  const inchSpan = serverData ? (max - min) * serverStep : 24; // all possible front end values, where only half are actual back end values. its written like this in-case some stinker goes and changes one of the height values, it doesnt brick saves
  const [displayInch, setDisplayInch] = useState((value - min) * serverStep);

  // setting the (invisible, remove format() if you need this to make sense) slider value to 4 is floor(4/4)*2+6 and turns into a back end value of 8, or 5'2" on the front end. i think that's math:tm:. please dont judge me if im doing this wrong
  // setting it to 8 is floor(8/4)*2+6, or 10 on the back end (which is a defined height value!!), front end is 5'6". bc theres a back end value on the new number, we update the sprite! yippee!
  const snapToBackend = (inch: number) =>
    min + Math.floor(inch / (serverStep * serverStep)) * serverStep;
  const inches = minimum_height + displayInch;
  const label = `${Math.floor(inches / 12)}'${inches % 12}"`;
  const adjust = (delta: number) => {
    const next = Math.max(0, Math.min(inchSpan, displayInch + delta));
    setDisplayInch(next);
    handleSetValue(snapToBackend(next));
  };
  return (
    <Stack align="center">
      <Stack.Item>
        <Button
          icon="minus"
          disabled={!serverData || displayInch <= 0}
          onClick={() => adjust(-1)}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Slider
          value={displayInch}
          minValue={0}
          maxValue={inchSpan}
          step={1}
          disabled={!serverData}
          format={() => `${label}`}
          onChange={(_e: Event, v: number) => {
            setDisplayInch(v);
            handleSetValue(snapToBackend(v));
          }}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="plus"
          disabled={!serverData || displayInch >= inchSpan}
          onClick={() => adjust(1)}
        />
      </Stack.Item>
    </Stack>
  );
}

export const height: FeatureNumeric = {
  name: 'Height',
  description: 'The height of your character.',
  component: HeightInput,
};
