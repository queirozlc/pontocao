import { View } from 'react-native'

import PetBanner from '@/assets/images/feed-banner.svg'
import { FeedHeader } from '@/components/home/feed-header'
import { PetCategories } from '@/components/home/pet-categories'
import { PetsNearYou } from '@/components/home/pets-near-you'
import { ContainerScroll } from '@/components/ui/base'
import { Constants } from '@/lib/constants'

export default function HomeScreen() {
  return (
    <ContainerScroll contentContainerClassName="gap-y-9">
      <View className="gap-4">
        <FeedHeader />
        <View className="items-center justify-center">
          <PetBanner
            width={Constants.DEVICE_WIDTH - 32}
            height={Constants.DEVICE_HEIGHT * 0.2}
          />
        </View>
        <PetCategories />
      </View>

      {/*
        The available sections are:
        - PetsNearYou (Pets próximos de você)
        - InstitutionsEvents (Eventos de instituições)
        - InstitutionsNearYou (Instituições próximas de você)
        - PetsForAdoption (Pets para adoção)
      */}
      <PetsNearYou />
    </ContainerScroll>
  )
}
