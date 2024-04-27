import { VariantProps, cva } from 'class-variance-authority'
import { ComponentPropsWithRef, forwardRef } from 'react'
import { Text, TouchableOpacity } from 'react-native'

import { cn } from '@/lib/utils'

type TouchableProps = ComponentPropsWithRef<typeof TouchableOpacity>

const badgeVariants = cva(
  'items-center justify-center rounded-full px-4 py-2',
  {
    variants: {
      variant: {
        outlined: 'border border-gray-400 dark:border-zinc-600'
      }
    },
    defaultVariants: {
      variant: 'outlined'
    }
  }
)

type BadgeProps = TouchableProps & VariantProps<typeof badgeVariants>

export const Badge = forwardRef<TouchableOpacity, BadgeProps>(
  ({ className, children, variant, ...props }, ref) => {
    return (
      <TouchableOpacity
        ref={ref}
        {...props}
        activeOpacity={0.5}
        className={cn(badgeVariants({ variant, className }))}
      >
        {children}
      </TouchableOpacity>
    )
  }
)

export const BadgeText = forwardRef<Text, ComponentPropsWithRef<typeof Text>>(
  ({ className, children, ...props }, ref) => {
    return (
      <Text
        ref={ref}
        {...props}
        className={cn(
          'font-sans-medium text-zinc-500 dark:text-zinc-200',
          className
        )}
      >
        {children}
      </Text>
    )
  }
)
