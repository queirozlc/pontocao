import { Feather } from '@expo/vector-icons'
import { Tabs } from 'expo-router'
import { useColorScheme } from 'react-native'
import colors from 'tailwindcss/colors'

import { Constants } from '@/lib/constants'

export default function AppLayout() {
  const theme = useColorScheme()

  return (
    <Tabs
      screenOptions={{
        tabBarLabelStyle: {
          fontFamily: Constants.FONT_SANS['500'],
          fontSize: 12
        },
        tabBarActiveTintColor: Constants.BRAND_COLOR,
        tabBarInactiveTintColor:
          theme === 'dark' ? colors.zinc[600] : colors.zinc[400]
      }}
    >
      <Tabs.Screen
        name="(home)"
        options={{
          headerShown: false,
          tabBarLabel: 'Início',
          tabBarIcon: ({ color }) => (
            <Feather name="home" size={24} color={color} />
          )
        }}
      />

      <Tabs.Screen
        name="maps"
        options={{
          tabBarLabel: 'Mapa',
          tabBarIcon: ({ color }) => (
            <Feather name="map" size={24} color={color} />
          )
        }}
      />
      <Tabs.Screen
        name="favs"
        options={{
          tabBarLabel: 'Favoritos',
          tabBarIcon: ({ color }) => (
            <Feather name="heart" size={24} color={color} />
          )
        }}
      />

      <Tabs.Screen
        name="profile"
        options={{
          tabBarLabel: 'Perfil',
          tabBarIcon: ({ color }) => (
            <Feather name="user" size={24} color={color} />
          )
        }}
      />
    </Tabs>
  )
}
