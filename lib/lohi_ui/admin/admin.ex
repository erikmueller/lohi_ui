defmodule LohiUi.Admin do
  @moduledoc """
  The Admin context.
  """
  alias LohiUi.Admin.Playlist

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists do
    {:ok, playlists} = Paracusia.MpdClient.Playlists.list_all()

    playlists
    |> Enum.map(&%Playlist{id: &1["playlist"], tag: &1["playlist"]})
    |> Enum.map(fn playlist ->
      {:ok, songs} = Paracusia.MpdClient.Playlists.list_info(playlist.id)
      %{playlist | songs: songs}
    end)
  end

  @doc """
  Gets a single playlist.

  ## Examples

      iex> get_playlist(123)
      %Playlist{}

      iex> get_playlist(456)
      nil

  """
  def get_playlist(id) do
    list_playlists
    |> Enum.find(&(&1.id == id))
  end

  @doc """
  Creates a playlist.
  """
  def create_playlist(tag, files) do
    playlist_path = Application.get_env(:lohi_ui, :playlist_directory)
    File.write(IO.inspect("#{playlist_path}/#{tag}.m3u"), Enum.join(files, "\n"))
  end

  def rescan do
    Paracusia.MpdClient.Database.rescan()
  end

  @doc """
  Updates a playlist.

  ## Examples

      iex> update_playlist(playlist, %{field: new_value})
      {:ok, %Playlist{}}

      iex> update_playlist(playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist(%Playlist{} = playlist, attrs) do
    # playlist
    # |> Playlist.changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a Playlist.

  ## Examples

      iex> delete_playlist(playlist)
      {:ok, %Playlist{}}

      iex> delete_playlist(playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist(%Playlist{} = playlist) do
    Paracusia.MpdClient.Playlists.remove(playlist.id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist changes.

  ## Examples

      iex> change_playlist(playlist)
      %Ecto.Changeset{source: %Playlist{}}

  """
  def change_playlist(%Playlist{} = playlist) do
    # Playlist.changeset(playlist, %{})
  end
end
