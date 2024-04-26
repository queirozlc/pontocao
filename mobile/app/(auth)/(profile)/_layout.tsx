import { Stack } from 'expo-router'

import { StepHeader } from '@/components/step-header'

export default function CompleteProfileLayout() {
  return (
    <Stack>
      <Stack.Screen
        name="index"
        options={{
          header: () => <StepHeader />
        }}
      />
    </Stack>
  )
}
