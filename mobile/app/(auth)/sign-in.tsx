import { Feather } from '@expo/vector-icons'
import { useNavigation, Link } from 'expo-router'
import { useState } from 'react'
import {
  Text,
  TouchableOpacity,
  View,
  Platform,
  KeyboardAvoidingView,
  useColorScheme
} from 'react-native'

import AppleDarkIcon from '@/assets/images/Apple_dark.svg'
import AppleLightIcon from '@/assets/images/Apple_light.svg'
import GoogleIcon from '@/assets/images/google.svg'
import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Constants } from '@/lib/constants'

export default function SignIn() {
  const [passwordVisible, setPasswordVisible] = useState(false)
  const theme = useColorScheme()
  const { goBack } = useNavigation()
  const AppleIcon = theme === 'dark' ? AppleDarkIcon : AppleLightIcon

  return (
    <Container className="gap-10">
      <View className="gap-5 pt-4">
        <TouchableOpacity onPress={goBack} activeOpacity={0.8}>
          <Feather
            name="arrow-left"
            size={36}
            color={theme === 'dark' ? '#fff' : '#000'}
          />
        </TouchableOpacity>

        <View className="justify-center gap-4">
          <Text className="font-sans-bold text-3xl text-zinc-900 dark:text-zinc-200">
            Bem-vindo de volta! 👋
          </Text>

          <Text className="font-sans-medium text-lg text-zinc-600 dark:text-zinc-400">
            Faça login para continuar! 🚀
          </Text>
        </View>
      </View>

      <KeyboardAvoidingView
        className="gap-6"
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      >
        <View className="gap-2">
          <Label>Qual seu email ?</Label>
          <Input
            placeholder="Digite seu email aqui"
            autoCapitalize="none"
            keyboardType="email-address"
          />
        </View>

        <View className="gap-2">
          <Label>Qual sua senha ?</Label>
          <View className="relative flex-row items-center">
            <TouchableOpacity
              activeOpacity={0.8}
              onPress={() => setPasswordVisible(!passwordVisible)}
              className="absolute right-4 z-10"
            >
              <Feather
                name={passwordVisible ? 'eye' : 'eye-off'}
                size={24}
                color={theme === 'dark' ? '#fff' : '#000'}
              />
            </TouchableOpacity>
            <Input
              placeholder="Digite a senha"
              className="pr-16"
              autoCapitalize="none"
              secureTextEntry={!passwordVisible}
            />
          </View>
        </View>

        <Button className="h-14">
          <Text className="text-center font-title-bold text-xl text-white">
            Entrar
          </Text>
        </Button>

        <Text className="text-center font-sans-medium text-zinc-600 dark:text-zinc-400">
          Ainda não tem uma conta?{' '}
          <Text className="text-brand-500" onPress={() => goBack()}>
            Crie uma conta
          </Text>
        </Text>

        <Link href="/forgot-password" asChild>
          <Text className="text-center font-sans-medium text-brand-500">
            Esqueceu a senha ?
          </Text>
        </Link>
      </KeyboardAvoidingView>

      <View className="flex-row items-center justify-center">
        <View className="h-px flex-1 bg-zinc-200 dark:bg-zinc-600" />
        <Text className="mx-2 text-sm text-zinc-400">ou</Text>
        <View className="h-px flex-1 bg-zinc-200 dark:bg-zinc-600" />
      </View>

      <View className="w-full gap-4">
        <Button variant="outlined" className="h-14">
          <GoogleIcon
            width={24}
            height={24}
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-zinc-900 dark:text-zinc-200">
            Entrar com Google
          </Text>
        </Button>

        <Button variant="outlined" className="h-14">
          <AppleIcon
            width={24}
            height={24}
            style={{
              position: 'absolute',
              left: 16
            }}
          />
          <Text className="text-center font-title-bold text-xl text-zinc-900 dark:text-zinc-200">
            Entrar com Apple
          </Text>
        </Button>
      </View>
    </Container>
  )
}
