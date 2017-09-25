defmodule Calculadora do
	def faz_operacao(a,b, tipo) do
 		if tipo == :soma do
 			a + b
 		else
 		 	a - b
 		end		

	end

end

Calculadora.faz_operacao(20,10, :soma) |> IO.puts
Calculadora.faz_operacao(20, 10, :subtracao) |> IO. puts			