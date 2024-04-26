import { VariantProps, cva } from 'class-variance-authority'
import { ComponentPropsWithRef, forwardRef } from 'react'
import { TextInput } from 'react-native'

import { Constants } from '@/lib/constants'
import { cn } from '@/lib/utils'

type InputBase = ComponentPropsWithRef<typeof TextInput>

const inputVariants = cva(
  'pl-4 pr-8 font-sans-medium text-zinc-900 dark:text-zinc-100',
  {
    variants: {
      variant: {
        outlined: 'rounded-xl border border-zinc-200 dark:border-zinc-600',
        solid:
          'rounded-xl border-none bg-zinc-100 dark:border-none dark:bg-zinc-700'
      },
      size: {
        full: 'h-16 w-full'
      }
    },
    defaultVariants: {
      variant: 'outlined',
      size: 'full'
    }
  }
)

type InputProps = InputBase & VariantProps<typeof inputVariants>

export const Input = forwardRef<TextInput, InputProps>(
  ({ variant, size, className, ...props }, ref) => {
    return (
      <TextInput
        ref={ref}
        className={cn(inputVariants({ variant, size, className }))}
        selectionColor={Constants.BRAND_COLOR}
        cursorColor={Constants.BRAND_COLOR}
        {...props}
      >
        {props.children}
      </TextInput>
    )
  }
)
