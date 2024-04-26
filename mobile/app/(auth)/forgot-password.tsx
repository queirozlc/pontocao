import { Feather, MaterialCommunityIcons } from '@expo/vector-icons'
import { useNavigation } from 'expo-router'
import {
  useColorScheme,
  View,
  Text,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform
} from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import colors from 'tailwindcss/colors'

import { Container } from '@/components/ui/base'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Constants } from '@/lib/constants'

export default function ForgotPassword() {
  const theme = useColorScheme()
  const { goBack } = useNavigation()
  const { bottom } = useSafeAreaInsets()

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
            Esqueceu sua senha? 🤔
          </Text>

          <Text className="font-sans-medium text-lg text-zinc-600 dark:text-zinc-400">
            Sem problemas! Informe seu email abaixo e te ajudaremos a recuperar
            o acesso.
          </Text>
        </View>
      </View>

      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        className="gap-3"
      >
        <Label>
          Conta pra gente qual é o email que você usou para se cadastrar
        </Label>

        <View className="relative flex-row items-center">
          <MaterialCommunityIcons
            name="email-outline"
            size={24}
            color={colors.zinc[400]}
            className="absolute left-4 z-10"
          />

          <Input
            variant="solid"
            placeholder="Digite seu email aqui"
            cursorColor={Constants.BRAND_COLOR}
            selectionColor={Constants.BRAND_COLOR}
            autoCapitalize="none"
            keyboardType="email-address"
            className="pl-14"
          />
        </View>
      </KeyboardAvoidingView>

      <View
        className="flex-1 justify-end"
        style={{
          paddingBottom: bottom + 32
        }}
      >
        <Button className="h-14">
          <Text className="text-center font-sans-bold text-xl text-white">
            Enviar
          </Text>
        </Button>
      </View>
    </Container>
  )
}
