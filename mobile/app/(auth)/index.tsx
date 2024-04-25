import { MaterialCommunityIcons } from '@expo/vector-icons'
import {
  Image,
  Text,
  TouchableOpacity,
  View,
  useColorScheme
} from 'react-native'

import AppleDarkIcon from '@/assets/images/Apple_dark.svg'
import AppleLightIcon from '@/assets/images/Apple_light.svg'
import FacebookIcon from '@/assets/images/facebook.svg'
import GoogleIcon from '@/assets/images/google.svg'
import { Container } from '@/components/ui/base'

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
        <TouchableOpacity
          className="h-16 items-center justify-center rounded-full border border-zinc-200 dark:border-zinc-600"
          activeOpacity={0.75}
        >
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
        </TouchableOpacity>

        <TouchableOpacity
          className="h-16 items-center justify-center rounded-full border border-zinc-200 dark:border-zinc-600"
          activeOpacity={0.75}
        >
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
        </TouchableOpacity>

        <TouchableOpacity
          className="h-16 items-center justify-center rounded-full border border-zinc-200 dark:border-zinc-600"
          activeOpacity={0.75}
        >
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
        </TouchableOpacity>

        <TouchableOpacity
          className="h-16 flex-row items-center justify-center rounded-full bg-brand-500"
          activeOpacity={0.75}
        >
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
        </TouchableOpacity>

        <TouchableOpacity
          className="h-16 flex-row items-center justify-center rounded-full bg-brand-500"
          activeOpacity={0.75}
        >
          <Text className="text-center font-title-bold text-xl text-white">
            Criar uma conta
          </Text>
        </TouchableOpacity>
      </View>
    </Container>
  )
}
