import { Feather } from '@expo/vector-icons'
import { useNavigation } from 'expo-router'
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

import { Row } from './ui/base'

type Props = {
  step: 1 | 2 | 3
}

export function StepHeader({ step }: Props) {
  const { top } = useSafeAreaInsets()
  const { goBack } = useNavigation()
  const theme = useColorScheme()
  const barProgress = (step * 100) / 3

  return (
    <Row
      style={{ paddingTop: top + 10 }}
      className="items-center justify-between gap-6 bg-white px-6 dark:bg-zinc-800"
    >
      <TouchableOpacity onPress={goBack} activeOpacity={0.8}>
        <Feather
          name="arrow-left"
          size={28}
          color={theme === 'dark' ? '#fff' : '#000'}
        />
      </TouchableOpacity>

      {/* Progress bar  */}
      <View className="mx-4 h-2 max-w-sm flex-1 rounded-full bg-gray-200 dark:bg-gray-600">
        <View
          className="h-full rounded-full bg-brand-500"
          style={{ width: `${barProgress}%` }}
        />
      </View>

      <Text className="font-sans-semibold text-xl text-zinc-900 dark:text-zinc-300">
        {step}/3
      </Text>
    </Row>
  )
}
