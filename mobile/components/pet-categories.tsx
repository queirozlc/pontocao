import { FlashList } from '@shopify/flash-list'
import { Text, TouchableOpacity, View } from 'react-native'

import { data } from '@/app/(auth)/match-options'

export function PetCategories() {
  return (
    <FlashList
      horizontal
      showsHorizontalScrollIndicator={false}
      estimatedItemSize={64}
      data={data}
      keyExtractor={({ id }) => id.toString()}
      ItemSeparatorComponent={() => <View className="w-4" />}
      renderItem={({ item: { name, icon } }) => (
        <View className="items-center gap-1">
          <TouchableOpacity
            activeOpacity={0.5}
            className="size-14 items-center justify-center rounded-full border border-gray-300 dark:border-zinc-600"
          >
            <Text className="text-center text-xl">{icon}</Text>
          </TouchableOpacity>

          <Text className="font-sans-medium text-sm text-zinc-900 dark:text-zinc-300">
            {name}
          </Text>
        </View>
      )}
    />
  )
}
