import { Feather } from '@expo/vector-icons'
import { Text, View } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import colors from 'tailwindcss/colors'

import { Badge, BadgeText } from '@/components/ui/badge'
import { Container, Row } from '@/components/ui/base'
import { Input } from '@/components/ui/input'

export default function Search() {
  const { top } = useSafeAreaInsets()

  return (
    <Container style={{ paddingTop: top + 60 }} className="gap-6">
      <Row className="items-center">
        <Feather
          name="search"
          size={24}
          color={colors.zinc['400']}
          className="absolute left-4"
        />
        <Input variant="outlined" className="rounded-full pl-14" />
      </Row>

      <View className="gap-4">
        <Row className="items-center justify-between">
          <Text className="font-sans-semibold text-lg text-zinc-800 dark:text-zinc-200">
            Recentes
          </Text>

          <Text className="font-sans-semibold text-lg text-brand-500">
            Limpar
          </Text>
        </Row>

        <Row className="items-center gap-4">
          <Badge>
            <BadgeText>Cachorro</BadgeText>
          </Badge>

          <Badge>
            <BadgeText>UVV</BadgeText>
          </Badge>

          <Badge>
            <BadgeText>ONG Amor de Bicho</BadgeText>
          </Badge>
        </Row>
      </View>
    </Container>
  )
}
