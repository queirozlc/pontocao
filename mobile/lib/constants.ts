import { Dimensions } from 'react-native'

export const Constants = {
  BRAND_COLOR: '#FF407D',
  FONT_SANS: {
    400: 'Inter_400Regular',
    500: 'Inter_500Medium'
  },
  DEVICE_WIDTH: Dimensions.get('window').width,
  DEVICE_HEIGHT: Dimensions.get('window').height
} as const
