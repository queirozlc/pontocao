import { VariantProps, cva } from 'class-variance-authority'
import { ComponentPropsWithRef, forwardRef } from 'react'
import { TouchableOpacity } from 'react-native'

import { cn } from '@/lib/utils'

type ButtonBase = ComponentPropsWithRef<typeof TouchableOpacity>

const buttonVariant = cva('flex-row items-center justify-center', {
  variants: {
    variant: {
      primary: 'rounded-full bg-brand-500',
      outlined: 'rounded-full border border-zinc-200 dark:border-zinc-600'
    },
    size: {
      full: 'h-16 w-full',
      icon: 'size-12'
    }
  },
  defaultVariants: {
    variant: 'primary',
    size: 'full'
  }
})

type ButtonProps = ButtonBase & VariantProps<typeof buttonVariant>

export const Button = forwardRef<TouchableOpacity, ButtonProps>(
  ({ variant, size, className, ...props }, ref) => {
    return (
      <TouchableOpacity
        activeOpacity={0.8}
        ref={ref}
        {...props}
        className={cn(buttonVariant({ variant, size, className }))}
      >
        {props.children}
      </TouchableOpacity>
    )
  }
)
