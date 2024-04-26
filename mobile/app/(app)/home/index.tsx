import { FeedHeader } from '@/components/feed-header'
import { PetCategories } from '@/components/pet-categories'
import { Container } from '@/components/ui/base'

export default function HomeScreen() {
  return (
    <Container className="gap-6">
      <FeedHeader />

      <PetCategories />
    </Container>
  )
}
