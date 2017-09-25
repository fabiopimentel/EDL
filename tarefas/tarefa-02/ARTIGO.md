![Elixir Banner](imagens/elixir-banner.png)


Sobre 
---

Elixir é uma linguagem de programação funcional, que roda sobre a Erlang VM, criada em __2012__ com o objetivo de servir à construção de sistemas escaláveis e sustentáveis. 

Seu criador é o brasileiro José Valim (https://github.com/josevalim) que foi um committer do projeto [Ruby on Rails](http://rubyonrails.org/) lidando com a parte de concorrência do framework.

A proximidade do criador com o Ruby teve influência direta na sintaxe da linguagem, que é ponto
mais amigável do que a Erlang que é a sua base.

As suas características principais são:

1) __Funcional__ - Functions e Modules, não existem objetos ou classes.
2) __Dinâmica__ - Tipos são checados na execução
3) __Compilada__ - Código fonte são transformados em bytecodes que rodam sobre a Erlang VM.
4) __Concorrência e Paralelismo__ - Usando o modelo de Actors

Elixir Fonte(.exs) ---> Erlang bytecode ----> Erlang VM


Onde a mágica começa?
---
Em linguagens funcionais a computação é tratada como a transformação de dados através de __funções__.

__f(x)__ : invoca a função f passando  x

__g(f(x),y)__: invoca a função g passando o retorno de f(x) e o dado y

Todas as funções no Elixir devem ser partes de um módulo:

```elixir
	defmodule Calculadora do
		def soma(a, b) do
			a+b
		end
	end		
```
No exemplo anterior é importante saber que a e b são argumentos e que uma função sempre retorna
a última linha. 

A utilização se daria através do código a seguir, onde o módulo Calculadora age como um namespace.	

```elixir
resultado = Calculadora.soma(1,2)
IO.puts "O resultado é #{resultado}" 

```
Sua execução pode-se ser feita tanto pelo terminal do Elixir, quanto por um fonte(.exs).

```
$ elixir teste1.exs 
O resultado é 3
```

O operador pipe
---

Visando a legibilidade do código em situações como a seguir:

```elixir
foo(bar(baz(nova_funcao(outra_funcao()))))
```

É possível realizar a mesma expessão usando o operador pipe que é representado por __|>__.
A grande diferença é que o pipe pega o resultado da esquerda e passa para a direita:

```
outra_funcao() |> nova_funcao() |> baz() |> bar() |> foo()

```
Sabendo disso podemos representar de maneira diferente a soma de números em um range:

```elixir
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
```

Pattern Matching
---

Em Elixir, o operador __=__ é na verdade o operador match, comparável ao sinal de igualdade da matemática.
Quando usado, a expressão inteira se torna uma equação e faz com que Elixir combine os valores do lado esquerdo
com os do lado direito. Se a comparação for bem sucedida, o valor da equação é retornado. Caso contrário um erro!

```elixir
iex(1)> a = 1
1
iex(2)> 1 = a
1
iex(3)> 2 = a 
** (MatchError) no match of right hand side value: 1
```

Pode-se perceber que o operador match realiza atribuições quando o lado esquerdo é uma variável.
Em casos que não se queira essa reassociação é possível usar o operador `pin`: __^__:

```elixir
iex(3)> x = 1
1
iex(4)> ^x = 3
** (MatchError) no match of right hand side value: 3
```

Os poderes com o Pattern Matching podem ser estendidos aos argumentos de uma função.
Veja o exemplo de um Calculadora que só realiza duas operações: adição e subtração:

```elixir
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
```
No exemplo usa-se o tipo __Átomo__ que é similar aos __símbolos__ no Ruby.
A grosso modo pode-se encarar como uma constante cujo o nome é seu valor.

Usando o conhecimento de Pattern Matching  podemos reescrever o código acima como o a seguir:

```elixir
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
```

Em linguagens funcionais como a Elixir o uso do condicional if é menos comum que outras linguagens.
Podemos continuar explorando exemplos maiores como o cálculo de Fibonnaci:

```elixir
defmodule Calculadora do
	def fibonnacci(0) do
 		0
	end

	def fibonnacci(1) do
		1
	end

	def fibonnacci(n) do
		fibonnacci(n-1)+ fibonnacci(n-2)
	end	

end

2 |> Calculadora.fibonnacci |> IO.puts
5 |> Calculadora.fibonnacci |> IO.puts
11|> Calculadora.fibonnacci |> IO.puts
```

Pode-se escrever menos quando só temos um linha no corpo de uma função:

```elixir
defmodule Calculadora do
	
	def fibonnacci(0), do: 0
	def fibonnacci(1), do: 1
	def fibonnacci(n), do: fibonnacci(n-1)+ fibonnacci(n-2)	

end

2 |> Calculadora.fibonnacci |> IO.puts
5 |> Calculadora.fibonnacci |> IO.puts
11 |> Calculadora.fibonnacci |> IO.puts
```

Metaprogramação
---
A Metaprogramação que é um recurso muito comum de linguagens dinâmicas permite a utilização de códigos
para escrever código. Em outras palavras podemos dizer que é a capacidade de gerar/alterar código em
tempo de execução.

Para entender esse conceito é necessário a compreensão de como as expressões são representadas.
Em Elixir, a árvore de sintaxe abstradta(AST), que é a representação interna do nosso código, é composta de tuplas.
Essas tuplas contêm três partes:

1) Nome da função
2) Metadados
2) Argumentos da função

```
#tupla para AST
{function_call, meta_data_for_context, argument_list}
```
Pode-se verificar essas estruturas internas com a função __quote__:

```elixir
iex(1)> quote do: 1+2
{:+, [context: Elixir, import: Kernel], [1, 2]}
```
Durante a compilação todo o nosso código será tranformado em um __AST__ antes de produzir um bytecode.
Entretanto existem 5 literais que irão continuar no mesmo formato:

1)Número(floats e integers):
```elixir
iex(5)> quote do: 1
1
```
2)Átomo:
```elixir
iex(6)> quote do: :adicao
:adicao
```
3)List
```elixir
iex(7)> quote do: [1,2,3]
[1, 2, 3]
```
4)String
```elixir
iex(8)> quote do: "Uerj"
"Uerj"
```
5)Tuplas(com dois elementos)
```elixir
iex(9)> quote do: {"Elixir",:funcional}      
{"Elixir", :funcional}
```
 
Entendido a estrutura interna do código para modificá-lo e injetar um novo valor usa-se a função __unquote__.
A proposta dessa função é receber uma expressão e imediatamente avaliar e inserir o código no lugar da chamada dela.
Em algumas linguagens como __Python__ o nome dela é __eval()_.


Observe o exemplo:

```elixir
iex(19)> operando = 10
10

iex(20)> quote do: 20 + operando
{:+, [context: Elixir, import: Kernel], [20, {:operando, [], Elixir}]}

iex(21)> quote do: 20 + unquote(operando)
{:+, [context: Elixir, import: Kernel], [20, 10]}
```
Como pode-se notar a função __unquote__ fez a AST do operando ser executada.


Agora que sabe-se sobre as duas funções pode-se entender como a metaprogramação funciona.
No Elixir existem funções especiais destinadas a retornar uma expressão entre aspas que será inserido no nosso código.
Essas funções recebem o nome de ___Macros___ e através delas temos tudo que é necessário para estender Elixir
e dinamicamente adicionar código a aplicação.
A principal diferença de uma Macro para outra função é que ela devolve um AST e todo parâmetro recebido autmaticamente
já é transformado em um AST, além da definição dela usar a palavra reservada `defmacro` em vez de `def`.



Um exemplo de debugger com Macros
----
Vamos tornar possível debugar a execução da nossa calculadora.
Fazendo com que toda chamada a `debug`, macro que será criada, ele nos informe a expressão que o método recebeu
por meio de um `print` além do resultado da operação.

Ou seja, deseja-se que ao executar:

```elixir
Calculadora.debug(1+2)
Calculadora.debug(2*5)
```
Tenha como saída e retornos:
```
Resultado de 1+2: 3
3
Resultado de 2*5: 10
10
```

Busca-se portando uma emplementação que quando a chamada __Calculadora.debug(1+2)__, o bytecode gerado corresponda
a alguma coisa como:

```elixir
resultado = 1+2
Calculadora.print("1+2", resultado)
resultado
````
Vamos analisar como essa Macro pode ser implementada :

```elixir
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

```

É importante ter em mente que  argumento enviado a uma macro já são `quoted`.
Então quando é chamado ``` Calculadora.debug(1+2)```, a macro __debug__ que é um função não irá receber __3__.
Em vez disso, receberia: ```quote do: 1+2```que relembrando é a tupla:

```elixir
{:+, [context: Elixir, import: Kernel], [1, 2]}

```
A observação acima é importante para entender a necessidade de dar um ```unquote(expressao_quote)``` para assim
poder obter o resultado da expressão para a Calculadora. E assim poder printar tanto a expressão quanto o resultado.
O único grande problema é que essa Calculadora está sempre debugando com o print de "1+2", mesmo quando
ela recebe uma chamada Calculadora.debug(2*5).
Para consertar isso é necessário obviamente que a String não seja fixa,ou seja, que ela dependa da expressão recebida.
Logo, para o exemplo ficar completo é necessário seguir o código abaixo de forma que seja guarado a expressão recebida como
String.



```elixir
defmodule Calculadora do
	defmacro debug(expressao_quote) do
		
		expressao_string = Macro.to_string(expressao_quote)

		quote do
			resultado = unquote(expressao_quote)
			Calculadora.print(unquote(expressao_string), resultado)
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
    Calculadora.debug(1+2)
    Calculadora.debug(1*2)
    Calculadora.debug(5-1)
  end
end

Main.test
```

O resultado da execução é:

```
$ elixir teste7.exs 
Resultado de 1 + 2: 3
Resultado de 1 * 2: 2
Resultado de 5 - 1: 4
```


Conclusão
----


Bibliografia
----
https://elixir-lang.org
https://elixirschool.com/pt/lessons/basics/pipe-operator/
https://speakerdeck.com/volcov/elixir-quem-e-este-pokemon
http://courseware.codeschool.com/try_elixir/slides/CodeSchool-TryElixir.pdf
https://dockyard.com/blog/2016/08/16/The-minumum-knowledge-you-need-to-start-metaprogramming-in-Elixir
http://theerlangelist.com/article/macros_1




(Não é necessário seguir a estrutura a seguir...)

# Introdução

# Origens e Influências

# Classificação

# Avaliação Comparativa

# Conclusão
