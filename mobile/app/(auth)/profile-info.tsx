import { createAvatar } from '@dicebear/core'
import * as funEmoji from '@dicebear/fun-emoji'
import { Feather } from '@expo/vector-icons'
import { Link } from 'expo-router'
import { useMemo } from 'react'
import { Text, TouchableOpacity, View } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { SvgXml } from 'react-native-svg'

import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

export default function ProfileInfo() {
  const { bottom } = useSafeAreaInsets()
  const avatar = useMemo(() => {
    return createAvatar(funEmoji, {
      // randomize seed
      seed: Math.random().toString(),
      randomizeIds: true,
      radius: 20,
      eyes: ['plain', 'closed', 'cute', 'wink', 'wink2'],
      mouth: [
        'cute',
        'lilSmile',
        'tongueOut',
        'smileTeeth',
        'smileLol',
        'wideSmile'
      ],
      size: 150,
      scale: 100
    })
  }, [])

  return (
    <Container style={{ paddingTop: 40 }} className="gap-4">
      <View className="gap-2 pb-8">
        <Text className="font-title-bold text-3xl text-zinc-900 dark:text-zinc-100">
          Quase lá! 🎉
        </Text>

        <Text className="font-title-medium text-lg text-zinc-600 dark:text-zinc-400">
          Agora, nos conte um pouco mais sobre você.
        </Text>
      </View>

      <View className="gap-8">
        <TouchableOpacity
          activeOpacity={0.8}
          className="relative size-32 items-center justify-center self-center rounded-full"
          style={{
            elevation: 2,
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.15,
            shadowRadius: 2
          }}
        >
          <SvgXml xml={avatar.toString()} width="100%" height="100%" />
          <View className="absolute -bottom-2 -right-2 rounded-full bg-brand-500 p-2">
            <Feather name="camera" size={24} color="#fff" />
          </View>
        </TouchableOpacity>

        <View className="gap-3">
          <Label>Como você quer ser chamado(a) ?</Label>
          <Input variant="solid" placeholder="Digite seu nome" />
        </View>
      </View>

      <View
        className="flex-1 justify-end"
        style={{
          paddingBottom: bottom + 32
        }}
      >
        <Link href="/(auth)/profile-info" asChild>
          <Button className="h-14">
            <Text className="text-center font-sans-bold text-xl text-white">
              Ir para o app
            </Text>
          </Button>
        </Link>
      </View>
    </Container>
  )
}
