import { MaterialCommunityIcons } from '@expo/vector-icons'
import { Link } from 'expo-router'
import { Image, Text, View, useColorScheme } from 'react-native'

import AppleDarkIcon from '@/assets/images/Apple_dark.svg'
import AppleLightIcon from '@/assets/images/Apple_light.svg'
import FacebookIcon from '@/assets/images/facebook.svg'
import GoogleIcon from '@/assets/images/google.svg'
import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'

export default function SignUpScreen() {
  const colorScheme = useColorScheme()

  const AppleIcon = colorScheme === 'dark' ? AppleDarkIcon : AppleLightIcon

  return (
    <Container className="gap-16 px-6">
      <View className="self-center pt-12">
        <Image
          source={require('@/assets/images/logobg.png')}
          resizeMode="contain"
          className="size-24 self-center rounded-full"
        />
      </View>

      <View className="gap-3">
        <Text className="text-center font-title-bold text-4xl text-zinc-800 dark:text-zinc-100">
          Olá, seja bem-vindo!
        </Text>

        <Text className="text-center text-lg text-zinc-600 dark:text-zinc-400">
          Faça login ou crie uma conta para começar
        </Text>
      </View>

      <View className="w-full gap-6 ">
        <Button variant="outlined">
          <GoogleIcon
            width={28}
            height={28}
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-zinc-900 dark:text-zinc-200">
            Continuar com Google
          </Text>
        </Button>

        <Button variant="outlined">
          <FacebookIcon
            width={28}
            height={28}
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-zinc-900 dark:text-zinc-200">
            Continuar com Facebook
          </Text>
        </Button>

        <Button variant="outlined">
          <AppleIcon
            width={28}
            height={28}
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-zinc-900 dark:text-zinc-200">
            Continuar com Apple
          </Text>
        </Button>

        <Button>
          <MaterialCommunityIcons
            name="email-outline"
            size={32}
            color="white"
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-white">
            Entrar com Email
          </Text>
        </Button>

        <Link href="/(auth)/sign-up" asChild>
          <Button>
            <Text className="text-center font-title-bold text-xl text-white">
              Criar uma conta
            </Text>
          </Button>
        </Link>
      </View>
    </Container>
  )
}
