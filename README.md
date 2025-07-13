# FIAP Farms - Gestão Agrícola Integrada 🚜

## 🎯 Sobre o Projeto

O **FIAP Farms** é uma solução mobile para gestão no agronegócio, desenvolvida para a Pós-Graduação da FIAP. O aplicativo centraliza e integra as operações essenciais de um produtor rural — **Vendas, Produção, Estoque e Metas** — em uma plataforma coesa, construída com Flutter e Firebase.

A arquitetura do projeto é modular e segue os princípios da **Clean Architecture**, garantindo um código desacoplado, escalável e de fácil manutenção, ideal para um produto robusto.

---

## ✨ Principais Funcionalidades

O app oferece uma experiência integrada, onde as ações em um módulo impactam diretamente os outros, criando um fluxo de trabalho automatizado.

### 📈 Vendas

Otimize o controle comercial com ferramentas visuais e de registro.

- **Registro de transações** com dedução automática do inventário.
- **Histórico de vendas** com filtros e ordenação dinâmica.
- **Dashboard visual** com um `PieChart` (`fl_chart`) para análise de performance de produtos.

### 🌱 Produção

Gerencie o ciclo de vida da produção, do plantio à colheita.

- **Rastreamento de lotes** por estágios: `Aguardando Início`, `Em Produção` e `Colhido`.
- **Integração com o estoque:** A colheita de um lote **automaticamente** adiciona a quantidade produzida ao catálogo de produtos disponíveis para venda.

### 📦 Estoque

Controle o inventário com um catálogo de produtos e insights em tempo real.

- **Gerenciamento do catálogo** de produtos (CRUD).
- **Dashboard de inventário** com `BarChart` para visualizar a distribuição de quantidades.
- **Cálculo automático do valor total** do estoque, oferecendo uma visão financeira clara.

### 🏆 Metas e Acompanhamento

Defina objetivos e monitore o progresso para impulsionar o desempenho.

- **Criação de metas** de **Vendas** (valor R$) e **Produção** (quantidade).
- **Acompanhamento de progresso** em tempo real com `LinearProgressIndicator`.
- **Cálculo automático:** O sistema busca os dados no Firestore para atualizar o avanço de cada meta.

### 🔔 Sistema Proativo de Notificações

Um dos diferenciais do app é o sistema de notificações locais, que engaja o usuário ativamente.

- **Gatilho por Desempenho:** Ao atingir 100% de uma meta de venda ou produção, uma notificação local é **automaticamente disparada** no dispositivo.
- **Feedback Imediato:** Parabeniza o usuário pela conquista, incentivando a busca por novos objetivos.
- **Tecnologia:** Implementado com o pacote `flutter_local_notifications`.

---

## 🏛️ Arquitetura e Padrões de Projeto

A estrutura do projeto foi pensada para promover as melhores práticas de desenvolvimento de software.

- **Arquitetura Modular (Feature-first):** O código é organizado em módulos (`/modules`) por funcionalidade. Essa abordagem promove o baixo acoplamento e permite que as equipes trabalhem em features de forma independente.

- **Separação de Camadas (Clean Architecture):**

  - `domain`: Contém as entidades de negócio puras (ex: `Product`, `Sale`), sem dependências externas.
  - `infrastructure`: Implementa a lógica de acesso a dados (ex: `FirestoreService`), atuando como a ponte entre o app e serviços externos como o Firebase.
  - `presentation`: Camada responsável pela UI (views, widgets, componentes).

- **Gerenciamento de Estado com Provider:**

  - **Injeção de Dependência:** `Provider` é usado para injetar serviços, como o `FirestoreService`, na árvore de widgets.
  - **Estado Compartilhado:** `ChangeNotifierProvider` gerencia o estado global, como as informações do usuário logado (`GlobalState`), garantindo que a UI reaja às mudanças de forma eficiente.

A estrutura de diretórios reflete esses conceitos:

```
lib/
├── domain/              # Entidades puras
├── modules/             # Módulos por funcionalidade
│   ├── sales/
│   │   ├── presentation/
│   │   └── infrastructure/
│   └── ...
├── services/            # Serviços (NotificationService)
├── store/               # Estado global (Provider)
└── main.dart            # Ponto de entrada e injeção de dependências
```

---

## 🛠️ Stack de Tecnologias

#### Core & Framework

- **Flutter** `^3.6.1`
- **Dart** `^3.6.1`

#### Backend (Firebase)

- **`firebase_core`**: Inicialização da plataforma.
- **`cloud_firestore`**: Banco de dados NoSQL.
- **`firebase_auth`**: Autenticação de usuários.

#### Gerenciamento de Estado

- **`provider`**: Injeção de dependência e estado reativo.

#### UI & Visualização

- **`fl_chart`**: Gráficos de pizza e barras.
- **`badges`**: Contadores para notificações.
- **`firebase_ui_auth` / `firebase_ui_oauth_google`**: Componentes de UI para login.

#### Utilitários

- **`intl`**: Formatação de datas e moedas (i18n).
- **`flutter_local_notifications`**: Disparo de notificações locais.
