defmodule Calculadora do
	
	def fibonnacci(0), do: 0
	def fibonnacci(1), do: 1
	def fibonnacci(n), do: fibonnacci(n-1)+ fibonnacci(n-2)	

end

2 |> Calculadora.fibonnacci |> IO.puts
5 |> Calculadora.fibonnacci |> IO.puts
11 |> Calculadora.fibonnacci |> IO.puts