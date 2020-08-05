# GameOfLife

O Jogo da Vida de Conway eh um sistema de automacao celular usado para exemplificar como a interacao entre entidades influencia na sua progressao evolutiva.

O programa se trata de uma simulacao de um mundo bi-dimensional onde cada entidade (celula) ocupa um espaco no plano cartesiano e se encontra em estado ativo ou inativo.
![TODO: Imagem]()

## Running

Cada simulacao pode ser iniciada rodando `GameOfLife.Game.new(options)` onde `options` eh uma Keyword com as seguintes chaves/opcoes:

| Opcao   | Tipo          | Requerido ? | Descricao |
| `:size` | `pos_integer` | Nao         | O tamanho de um lado no plano simulado |