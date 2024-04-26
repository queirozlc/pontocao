import { Link } from 'expo-router'
import { Text, TouchableOpacity, View } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'

export default function ChooseProfile() {
  const { bottom } = useSafeAreaInsets()

  return (
    <Container className="gap-10">
      <View className="gap-2">
        <Text className="font-title-bold text-3xl text-zinc-900 dark:text-zinc-100">
          Conta pra gente um pouco sobre você 👩
        </Text>

        <Text className="font-title-medium text-lg text-zinc-600 dark:text-zinc-400">
          Você é um tutor buscando um novo amigo ou é um doador ou organização ?
        </Text>
      </View>

      <View className="gap-5">
        <TouchableOpacity
          activeOpacity={0.8}
          className="h-16 items-center justify-center rounded-md border border-gray-200 active:border-brand-500 active:bg-brand-500/20 dark:border-gray-500"
        >
          <Text className="font-sans-medium text-lg text-zinc-600 dark:text-zinc-400">
            Sou um tutor
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          activeOpacity={0.8}
          className="h-16 items-center justify-center rounded-md border border-gray-200 active:border-brand-500 active:bg-brand-500/20 dark:border-gray-500"
        >
          <Text className="font-sans-medium text-lg text-zinc-600 dark:text-zinc-400">
            Sou um doador ou organização
          </Text>
        </TouchableOpacity>
      </View>

      <View
        className="flex-1 justify-end"
        style={{
          paddingBottom: bottom + 32
        }}
      >
        <Link href="/(auth)/match-options" asChild>
          <Button className="h-14">
            <Text className="text-center font-sans-bold text-xl text-white">
              Próximo
            </Text>
          </Button>
        </Link>
      </View>
    </Container>
  )
}
