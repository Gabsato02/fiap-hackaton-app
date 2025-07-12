# FIAP Farms - Gestão Agrícola Integrada

## 🎯 Sobre o Projeto

O **FIAP Farms** é um aplicativo mobile de gestão para o agronegócio, desenvolvido como projeto para a pós-graduação da FIAP. A solução centraliza o controle de vendas, produção, estoque e metas, oferecendo uma visão completa e integrada das operações agrícolas.

O app foi construído utilizando uma arquitetura modular, facilitando a manutenção e a escalabilidade. Cada funcionalidade principal é encapsulada em seu próprio módulo, garantindo um código organizado e desacoplado.

## ✨ Funcionalidades Principais

O projeto é dividido em quatro módulos principais, acessíveis através de uma navegação por abas intuitiva:

### 1\. 📈 Vendas

O módulo de vendas permite o registro e acompanhamento completo das transações comerciais.

- **Registro de Vendas:** Adicione novas vendas informando o produto, quantidade, data e valor.
- **Edição e Exclusão:** Modifique ou remova registros de vendas existentes.
- **Histórico e Filtragem:** Visualize uma lista completa de vendas, com opções para ordenar por data, produto, quantidade ou valor.
- **Dashboard Visual:** Um gráfico de pizza (`PieChart`) exibe a distribuição percentual das vendas por produto, oferecendo insights rápidos sobre os itens mais vendidos.
- **Integração com Estoque:** Ao registrar uma venda, a quantidade do produto é automaticamente deduzida do estoque.

\<hr\>

### 2\. 🌱 Produção

Gerencie todo o ciclo de produção agrícola, desde o plantio até a colheita.

- **Controle de Ciclo:** Acompanhe os lotes de produção em diferentes estágios: `Aguardando Início`, `Em Produção` e `Colhido`.
- **Adição e Edição:** Registre novas atividades de produção e atualize as existentes.
- **Colheita Integrada:** Ao marcar um lote como "colhido", a quantidade produzida é automaticamente adicionada ao módulo de **Estoque**, pronta para ser vendida.

\<hr\>

### 3\. 📦 Estoque

Mantenha um catálogo detalhado dos seus produtos e controle os níveis de inventário em tempo real.

- **Catálogo de Produtos:** Adicione, edite ou remova produtos do catálogo, definindo nome, preço e quantidade inicial.
- **Visualização Gráfica:** Um gráfico de barras (`BarChart`) mostra a distribuição das quantidades de cada produto no estoque.
- **Valor Total do Estoque:** Um card de destaque exibe o valor monetário total do inventário, calculado em tempo real.

\<hr\>

### 4\. 🏆 Metas

Defina e acompanhe metas de desempenho para manter a equipe focada e motivada.

- **Criação de Metas:** Estabeleça metas de **vendas** (baseadas em valor monetário) ou de **produção** (baseadas em quantidade).
- **Definição de Período:** Associe cada meta a um período específico (data de início e fim).
- **Acompanhamento Automático:** O progresso de cada meta é calculado e atualizado automaticamente, buscando os dados reais de vendas e produção no Firestore.
- **Visualização de Progresso:** Barras de progresso (`LinearProgressIndicator`) mostram de forma clara o quão perto você está de atingir cada objetivo.

---

## 🛠️ Tecnologias Utilizadas

- **Framework:** **Flutter** `^3.6.1`
- **Linguagem:** **Dart** `^3.6.1`
- **Backend & Banco de Dados:** **Firebase**
  - `firebase_auth`: Autenticação de usuários com E-mail/Senha e Google.
  - `cloud_firestore`: Banco de dados NoSQL para armazenar todas as informações (vendas, produtos, metas, etc.).
- **Gerenciamento de Estado:** **Provider** `^6.1.5` para gerenciamento de estado reativo e centralizado (ex: informações do usuário logado).
- **Gráficos:** **fl_chart** `^0.71.0` para a criação dos gráficos interativos de vendas e estoque.
- **Autenticação UI:** Pacotes `firebase_ui_auth`, `firebase_ui_oauth_google` para fornecer uma interface de login pronta e customizável.
- **Utilitários:**
  - `intl`: Para formatação de datas e valores monetários.
  - `cupertino_icons`: Ícones padrão do iOS.

## 🏛️ Arquitetura

O projeto segue uma arquitetura modular, com a seguinte estrutura de diretórios:

```
lib/
├── domain/
│   └── entities/      # Classes de modelo (Product, Sale, Goal, etc.)
├── modules/
│   ├── login/         # Tela e lógica de autenticação
│   ├── sales/         # Módulo de Vendas (views, componentes, repositórios)
│   ├── production/    # Módulo de Produção
│   ├── stock/         # Módulo de Estoque
│   ├── goals/         # Módulo de Metas
│   └── host/          # Componentes globais (AppBar, Navegação)
├── store/
│   └── index.dart     # Estado global com Provider (GlobalState)
├── utils/
│   └── index.dart     # Funções utilitárias (ex: showConfirmDialog)
├── main.dart          # Ponto de entrada da aplicação e definição de rotas
└── firebase_options.dart # Configurações do Firebase para cada plataforma
```

- **Domain:** Contém as entidades de negócio puras, sem dependências de frameworks.
- **Modules:** Cada pasta representa uma feature. Dentro de cada uma, a estrutura é dividida em `presentation` (widgets e views), `infrastructure` (repositórios que interagem com o Firebase) e, quando necessário, `application` (casos de uso).
- **Store:** Centraliza o estado que precisa ser compartilhado entre diferentes módulos, como as informações do usuário autenticado.
