defmodule Calculadora do
	def faz_operacao(a,b, :soma) do
 			a + b
	end

	def faz_operacao(a,b, :subtracao) do
		a-b
	end	

end

Calculadora.faz_operacao(20,10, :soma) |> IO.puts
Calculadora.faz_operacao(20, 10, :subtracao) |> IO. puts