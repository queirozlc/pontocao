import { ComponentPropsWithRef, forwardRef } from 'react'
import { View } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

import { cn } from '@/lib/utils'

type ViewProps = ComponentPropsWithRef<typeof View>

export const Container = forwardRef<View, ViewProps>((props, ref) => {
  const { top } = useSafeAreaInsets()

  return (
    <View
      {...props}
      ref={ref}
      style={[{ paddingTop: top }, props.style]}
      className={cn('flex-1 bg-white px-6 dark:bg-zinc-800', props.className)}
    >
      {props.children}
    </View>
  )
})

export const Row = forwardRef<View, ViewProps>((props, ref) => {
  return (
    <View {...props} ref={ref} className={cn('flex flex-row', props.className)}>
      {props.children}
    </View>
  )
})
