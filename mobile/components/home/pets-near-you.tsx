import { Feather } from '@expo/vector-icons'
import { FlashList } from '@shopify/flash-list'
import { FlatList, Image, Text, View } from 'react-native'

import { Row } from '../ui/base'

import { Constants } from '@/lib/constants'

type PetsMock = {
  id: number
  name: string
  image: string
  distance: number
  location: string
}

const pets: PetsMock[] = [
  {
    id: 1,
    name: 'Luna',
    image: require('@/assets/images/dog1.jpeg'),
    distance: 1.2,
    location: 'Rua dos Bobos, nº 0'
  },
  {
    id: 2,
    name: 'Bolt',
    image: require('@/assets/images/dog2.jpeg'),
    distance: 1.2,
    location: 'Barueri, SP'
  },
  {
    id: 3,
    name: 'Athena',
    // other image link
    image: require('@/assets/images/cat1.jpeg'),
    distance: 1.0,
    location: 'Rio de Janeiro, RJ'
  },
  {
    id: 4,
    name: 'Thor',
    image: require('@/assets/images/cat2.jpeg'),
    distance: 2.4,
    location: 'Campinas, SP'
  }
]

export function PetsNearYou() {
  return (
    <View className="gap-4">
      <Row className="items-center justify-between">
        <Text className="font-sans-medium text-lg text-zinc-900 dark:text-zinc-200">
          Mais próximos de você
        </Text>

        <Text className="font-sans-semibold text-lg text-brand-500">
          Ver mais
        </Text>
      </Row>

      <FlashList
        data={pets.slice(0, 4)}
        horizontal
        showsHorizontalScrollIndicator={false}
        keyExtractor={({ id }) => id.toString()}
        ItemSeparatorComponent={() => <View className="w-4" />}
        renderItem={({ item: { name, location, distance } }) => (
          <View className="gap-2">
            <Image
              source={require('@/assets/images/dog1.jpeg')}
              resizeMode="contain"
              className="size-36 rounded-xl"
            />

            <Row className="items-center justify-between">
              <Text className="font-sans-semibold text-lg text-zinc-600 dark:text-zinc-200">
                {name}
              </Text>

              <Row className="items-center gap-1">
                <Feather
                  name="map-pin"
                  size={16}
                  color={Constants.BRAND_COLOR}
                />
                <Text className="font-sans-medium text-sm text-zinc-400 dark:text-zinc-300">
                  {distance} km
                </Text>
              </Row>
            </Row>

            <Text className="font-sans-medium text-sm text-zinc-400 dark:text-zinc-300">
              {location}
            </Text>
          </View>
        )}
        estimatedItemSize={129}
      />
    </View>
  )
}
