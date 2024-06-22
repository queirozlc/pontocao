defmodule PontoCaoWeb.Uploaders.Avatar do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @allowed_extensions ~w(.jpg .jpeg .png)

  def filename(version, {file, user}) do
    # It is desirable for this name to be unique
    "#{file.file_name}_#{user.id}_#{version}"
  end

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension =
      file.filename
      |> Path.extname()
      |> String.downcase()

    Enum.member?(@allowed_extensions, file_extension)
  end
end
