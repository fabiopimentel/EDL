defmodule Calculadora do
	def imprime_soma(range) do
 		IO.puts Enum.sum(range)
	end

	def imprime_soma_pipe(range) do

		range |> Enum.sum |> IO.puts
	end
end

Calculadora.imprime_soma(1..10)
Calculadora.imprime_soma_pipe(1..10)		