import { ComponentPropsWithRef, forwardRef } from 'react'
import { Text } from 'react-native'

import { cn } from '@/lib/utils'

type LabelProps = ComponentPropsWithRef<typeof Text>

export const Label = forwardRef<Text, LabelProps>(
  ({ children, className, ...props }, ref) => {
    return (
      <Text
        ref={ref}
        className={cn(
          'font-sans-semibold text-lg text-zinc-900 dark:text-zinc-200',
          className
        )}
        {...props}
      >
        {children}
      </Text>
    )
  }
)
