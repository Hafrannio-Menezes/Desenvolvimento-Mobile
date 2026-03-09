# Desenvolvimento Mobile - Exercicios

Repositorio unico para armazenar varios exercicios e projetos feitos em aula.

## Estrutura do repositorio

```text
.
|- exercicios/
|  |- dart/
|  |  |- caixa_de_loja/
|  |  |- calculadora/
|  |- flutter/
|- aulas/
|- anotacoes/
```

## Como usar este repositorio

- Cada exercicio deve ficar em uma pasta propria dentro de `exercicios/<tecnologia>/`.
- Use nomes curtos e descritivos, por exemplo: `login_basico`, `consumo_api`, `lista_tarefas`.
- Mantenha cada projeto com seu proprio `README.md` explicando objetivo, execucao e regras.

## Criar novo exercicio Dart (template)

Use o script abaixo para criar um novo projeto Dart console com README e CHANGELOG padrao:

```powershell
cd scripts
.\criar_exercicio_dart.ps1 -Nome "nome_do_exercicio" -Descricao "Resumo do exercicio"
```

Exemplo:

```powershell
.\criar_exercicio_dart.ps1 -Nome "calculadora_imc" -Descricao "Calculo de IMC com validacoes"
```

O projeto sera criado em `exercicios/dart/<nome_do_exercicio>`.

## Exercicios atuais

| Tecnologia | Projeto | Caminho |
| --- | --- | --- |
| Dart | Caixa de Loja | `exercicios/dart/caixa_de_loja` |
| Dart | Calculadora CLI | `exercicios/dart/calculadora` |

## Padrao sugerido para novos exercicios

```bash
# exemplo
mkdir -p exercicios/dart/meu_novo_exercicio
cd exercicios/dart/meu_novo_exercicio
dart create -t console-simple .
```

## Observacoes

- `aulas/`: materiais de cada aula (slides, enunciados, arquivos auxiliares).
- `anotacoes/`: resumos e observacoes pessoais.
