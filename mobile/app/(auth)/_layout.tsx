import { Stack } from 'expo-router'

import { StepHeader } from '@/components/step-header'

export default function AuthLayout() {
  return (
    <Stack screenOptions={{ headerShown: false }} initialRouteName="index">
      <Stack.Screen name="index" />
      <Stack.Screen name="sign-up" />
      <Stack.Screen name="sign-in" />
      <Stack.Screen name="forgot-password" />
      <Stack.Screen
        name="choose-profile"
        options={{
          header: () => <StepHeader step={1} />,
          headerShown: true
        }}
      />
      <Stack.Screen
        name="match-options"
        options={{
          header: () => <StepHeader step={2} />,
          headerShown: true
        }}
      />
    </Stack>
  )
}
