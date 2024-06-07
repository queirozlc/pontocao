defmodule PontoCao.Commons.Cep.Address do
  defstruct [:postal_code, :state, :city, :neighborhood, :street, :valid?]

  @type t :: %__MODULE__{
          postal_code: String.t(),
          state: String.t(),
          city: String.t(),
          neighborhood: String.t(),
          street: String.t(),
          valid?: boolean()
        }
end
