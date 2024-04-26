import { FlashList } from '@shopify/flash-list'
import { Link } from 'expo-router'
import { useState } from 'react'
import { Text, TouchableOpacity, View } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

type MockData = {
  id: number
  name: string
  icon: string
}

const data: MockData[] = [
  {
    id: 1,
    name: 'Cachorros',
    icon: '🐕'
  },
  {
    id: 2,
    name: 'Gatos',
    icon: '🐈'
  },
  {
    id: 3,
    name: 'Peixes',
    icon: '🐠'
  },
  {
    id: 4,
    name: 'Pássaros',
    icon: '🦜'
  },
  {
    id: 5,
    name: 'Roedores',
    icon: '🐹'
  },
  {
    id: 6,
    name: 'Coelhos',
    icon: '🐇'
  },
  {
    id: 7,
    name: 'Outros',
    icon: '🐾'
  }
]

export default function MatchOptions() {
  const { bottom } = useSafeAreaInsets()
  const [selected, setSelected] = useState<number[]>([])

  return (
    <Container style={{ paddingTop: 40 }} className="gap-10">
      <FlashList
        data={data}
        keyExtractor={({ id }) => id.toString()}
        estimatedItemSize={100}
        numColumns={3}
        ItemSeparatorComponent={() => <View className="h-4" />}
        showsVerticalScrollIndicator={false}
        extraData={selected}
        renderItem={({ item: { name, icon, id } }) => (
          <TouchableOpacity
            activeOpacity={0.8}
            className={cn(
              'min-w-28 items-center justify-center rounded-md border border-gray-200 px-4 py-8 dark:border-zinc-600',
              selected.includes(id) &&
                'border-brand-500 bg-brand-500/20 dark:border-brand-500'
            )}
            onPress={() => {
              setSelected(prev =>
                prev.includes(id)
                  ? prev.filter(item => item !== id)
                  : [...prev, id]
              )
            }}
          >
            <View className="items-center justify-center gap-2">
              <Text className="text-4xl">{icon}</Text>
              <Text className="font-sans-regular text-zinc-900 dark:text-zinc-300">
                {name}
              </Text>
            </View>
          </TouchableOpacity>
        )}
        ListHeaderComponent={() => (
          <View className="gap-2 pb-8">
            <Text className="font-title-bold text-3xl text-zinc-900 dark:text-zinc-100">
              Vamos te ajudar a encontrar um novo amigo 🐶
            </Text>

            <Text className="font-title-medium text-lg text-zinc-600 dark:text-zinc-400">
              Escolha as opções que mais se encaixam com você, não se preocupe,
              você poderá alterar isso depois.
            </Text>
          </View>
        )}
      />

      <View
        className="justify-end"
        style={{
          paddingBottom: bottom + 32
        }}
      >
        <Link href="/(auth)/profile-info" asChild>
          <Button className="h-14" disabled={selected.length === 0}>
            <Text className="text-center font-sans-bold text-xl text-white">
              Próximo
            </Text>
          </Button>
        </Link>
      </View>
    </Container>
  )
}
