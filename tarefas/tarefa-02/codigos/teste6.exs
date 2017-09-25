defmodule Calculadora do
	defmacro debug(expressao_quote) do
		
		quote do
			resultado = unquote(expressao_quote)
			Calculadora.print("1+2", resultado)
			resultado
		end
 			
	end

	def print(string_representation, result) do
    	IO.puts "Resultado de #{string_representation}: #{result}"
  	end
end

defmodule Main do
  require Calculadora

  def test do
    Calculadora.debug(1+2+1)
  end
end

Main.test
