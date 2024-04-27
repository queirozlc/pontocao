import { Ionicons, Feather } from '@expo/vector-icons'
import { Link } from 'expo-router'
import { View, Text, TouchableOpacity, useColorScheme } from 'react-native'

import { Row } from '@/components/ui/base'

export function FeedHeader() {
  const theme = useColorScheme()

  return (
    <Row className="items-center justify-between">
      <View className="gap-1">
        <Text className="font-sans-medium text-zinc-600 dark:text-zinc-400">
          Localização atual
        </Text>

        <Text className="font-title-bold text-2xl text-zinc-900 dark:text-zinc-300">
          São Paulo, SP
        </Text>
      </View>

      <Row className="items-center gap-2">
        <Link href="/(app)/home/search" asChild>
          <TouchableOpacity
            activeOpacity={0.8}
            className="rounded-full border border-gray-200 p-2 dark:border-zinc-600"
          >
            <Ionicons
              name="search"
              size={20}
              color={theme === 'dark' ? '#fff' : '#000'}
            />
          </TouchableOpacity>
        </Link>

        <TouchableOpacity
          activeOpacity={0.8}
          className="rounded-full border border-gray-200 p-2 dark:border-zinc-600"
        >
          <Feather
            name="bell"
            size={20}
            color={theme === 'dark' ? '#fff' : '#000'}
          />
        </TouchableOpacity>
      </Row>
    </Row>
  )
}
