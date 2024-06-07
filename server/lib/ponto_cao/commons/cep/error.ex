defmodule PontoCao.Commons.Cep.Error do
  defstruct [:postal_code, :message, :status_code, :valid?]

  @type t :: %__MODULE__{
          postal_code: String.t(),
          message: String.t(),
          status_code: integer(),
          valid?: boolean()
        }
end
