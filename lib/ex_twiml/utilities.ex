defmodule ExTwiml.Utilities do
  @moduledoc """
  A grab bag of helpful functions used to generate XML.
  """

  import String, only: [downcase: 1]

  @doc """
  Generates an XML tag.

  ## Examples

      iex> ExTwiml.Utilities.create_tag(:opening, :say, [voice: "woman"])
      "<Say voice=\\"woman\\">"

      iex> ExTwiml.Utilities.create_tag(:self_closed, :pause, [length: 5])
      "<Pause length=\\"5\\" />"

      iex> ExTwiml.Utilities.create_tag(:closing, :say)
      "</Say>"
  """
  @spec create_tag(atom, atom, Keyword.t) :: String.t
  def create_tag(type, name, options \\ []) do
    do_create_tag(type, capitalize(name), xml_attributes(options))
  end

  defp do_create_tag(:self_closed, name, attributes) do
    "<" <> name <> attributes <> " />"
  end

  defp do_create_tag(:opening, name, attributes) do
    "<" <> name <> attributes <> ">"
  end

  defp do_create_tag(:closing, name, _attributes) do
    "</" <> name <> ">"
  end

  @doc """
  Capitalize a string or atom.

  ## Examples

      iex> ExTwiml.Utilities.capitalize(:atom)
      "Atom"

      iex> ExTwiml.Utilities.capitalize("string")
      "String"
  """
  @spec capitalize(atom) :: String.t
  def capitalize(atom) do
    String.capitalize to_string(atom)
  end

  @doc """
  Generate a list of HTML attributes from a keyword list. Keys will be converted
  to headless camelCase.

  See the `camelize/1` function for more details.

  ## Examples

      iex> ExTwiml.Utilities.xml_attributes([digits: 1, finish_on_key: "#"])
      " digits=\\"1\\" finishOnKey=\\"#\\""
  """
  @spec xml_attributes(list) :: String.t
  def xml_attributes(attrs) do
    for {key, val} <- attrs,
        into: "",
        do: " #{camelize(key)}=\"#{val}\""
  end

  @doc """
  Convert a string to headless camelCase.

  ## Examples

      ...> ExTwiml.Utilities.camelize("finish_on_key")
      "finishOnKey"
  """
  @spec camelize(String.t) :: String.t
  def camelize(string) do
    string = to_string(string)
    parts = String.split(string, "_", parts: 2)
    do_camelize(parts, string)
  end

  defp do_camelize([first], original) when first == original do
    original
  end

  defp do_camelize([first], _) do
    downcase(first)
  end

  defp do_camelize([first, rest], _) do
    downcase(first) <> Mix.Utils.camelize(rest)
  end
end
