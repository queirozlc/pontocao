import { Feather } from '@expo/vector-icons'
import { Stack, useNavigation } from 'expo-router'
import { TouchableOpacity, useColorScheme } from 'react-native'

export default function HomeLayout() {
  const theme = useColorScheme()
  const { goBack } = useNavigation()

  return (
    <Stack
      screenOptions={{
        headerTransparent: true,
        headerBackTitleVisible: false,
        headerLeft() {
          return (
            <TouchableOpacity onPress={goBack} activeOpacity={0.8}>
              <Feather
                name="arrow-left"
                size={24}
                color={theme === 'dark' ? '#fff' : '#000'}
              />
            </TouchableOpacity>
          )
        }
      }}
    >
      <Stack.Screen
        name="index"
        options={{
          headerShown: false
        }}
      />

      <Stack.Screen
        name="search"
        options={{
          headerTitle: 'Pesquisar'
        }}
      />
    </Stack>
  )
}
