# eInspect

Aplicativo Flutter de inspeção de campo desenvolvido para o desafio técnico da Orbytis. O eInspect atende técnicos que trabalham em subestações e redes de distribuição, frequentemente fora da cobertura de rede: a coleta é persistida localmente e a transmissão é retomada quando a conectividade retorna.

## Visão geral

- Login seguro com Bearer JWT.
- Listagem, filtro e detalhamento de ordens de serviço (OS).
- Formulário com observação, foto permanente e coordenadas GPS.
- Geofencing preventivo de 200 m.
- Fila de sincronização offline com retentativas automáticas e manuais.
- Histórico local separado por usuário do aparelho.

O backend usado no desafio é uma API mock Node.js/Express em `localhost:3000`. Consulte o [contrato da API](docs/CONTRATO_API.md) e o [escopo original](docs/DESAFIO_CANDIDATO.md).

## Stack

| Área          | Tecnologia                                        |
| ------------- | ------------------------------------------------- |
| Aplicativo    | Flutter (canal Stable) e Dart                     |
| Estado        | `flutter_bloc` (BLoC/Cubit)                       |
| Persistência  | SQLite via `sqflite`                              |
| HTTP          | `dio`                                             |
| Modelos       | Freezed e `json_serializable`                     |
| Dispositivo   | `geolocator`, `image_picker`, `path_provider`     |
| Conectividade | `connectivity_plus`                               |
| Injeção       | `get_it` (Service Locator, restrito à composição) |
| API mock      | Node.js, Express, json-server e Multer            |

## Como executar

### Pré-requisitos

- Flutter SDK no canal Stable, com `flutter doctor` sem pendências relevantes;
- Android SDK, dispositivo físico ou emulador Android;
- Node.js 18 ou superior e npm;
- USB debugging habilitado para aparelho físico.

### API mock

```bash
cd mock-api
npm install
npm start
```

A API fica em `http://localhost:3000`.

| Usuário                  | Senha      |
| ------------------------ | ---------- |
| `tecnico@orbytis.com.br` | `123456`   |
| `admin@orbytis.com.br`   | `admin123` |

### Rede Android

| Ambiente             | `API_BASE_URL`                              |
| -------------------- | ------------------------------------------- |
| Emulador Android     | `http://10.0.2.2:3000`                      |
| Celular na mesma LAN | `http://IP_DA_MAQUINA:3000`                 |
| Celular via USB      | `http://127.0.0.1:3000` após reverse do ADB |

O task `adb-reverse` do VS Code pode fazer o encaminhamento automaticamente. Manualmente:

```powershell
adb -d reverse tcp:3000 tcp:3000
```

Se o reverse não estiver disponível, use o IP local da máquina e libere a porta 3000 no firewall. No emulador, `localhost` aponta para o emulador; use `10.0.2.2`.

### Dependências, geração e execução

Na raiz do projeto:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Substitua a URL pelo ambiente escolhido. Em aparelho físico via USB, use `http://127.0.0.1:3000`. O task `flutter-preparation` encadeia reverse e build runner.

Testes:

```bash
flutter test
```

Para exercitar a fila, conclua uma inspeção sem rede, encerre e reabra o app e restabeleça a conexão. O registro deve sobreviver e ser sincronizado sem duplicidade.

## Arquitetura

O projeto combina **Clean Architecture** com organização **Feature-First**. Cada feature isola domínio, dados e apresentação:

```text
lib/
├── core/                 utilitários globais e composição transversal
│   ├── database/         db_helper e tabelas SQLite
│   ├── di/               composição das dependências
│   ├── errors/           Failure e tratamento tipado
│   ├── network/          Dio, conectividade e status da rede
│   ├── routing/          AppRouter e rotas protegidas
│   └── widgets/          componentes compartilhados, como OfflineBanner
├── features/
│   ├── auth/             autenticação e sessão
│   ├── work_orders/      consulta e apresentação das OSs
│   └── inspections/      formulário, histórico e sincronização
└── main.dart             bootstrap
```

```text
Presentation (Page + BLoC) -> Domain (Entity + Repository contract)
              ^
              |
         Data (Model + DataSource + RepositoryImpl)
              |
          SQLite / API mock
```

O `Service Locator` é usado apenas na composição. A criação dos `BlocProvider`s fica centralizada no `AppRouter`; páginas e widgets não chamam `sl<T>()` dentro de `build()`. Isso mantém a UI declarativa, evita instanciação durante rebuilds e explicita o ciclo de vida dos blocs por rota.

Os modelos são imutáveis e gerados com Freezed. **Entity** é o contrato do domínio, sem detalhes de SQLite ou JSON; **Model** pertence à camada Data e converte entre Entity, linhas SQLite e payloads JSON/multipart.

## Offline-first e fila de sincronização

O SQLite é a fonte de verdade local. Rascunhos não dependem da API; concluir uma inspeção muda o registro para `pending`.

```text
salvar -> [draft] -> concluir -> [pending] --POST OK--> [synced]
              \--falha--------> [failed]
                    |
                   Reenviar
                    v
                   [pending]
```

### Idempotência

Cada inspeção recebe no dispositivo um `clientId` baseado em UUID v4. O mesmo identificador é reutilizado em todas as tentativas. A API reconhece um `clientId` já processado e devolve o registro existente, em vez de criar outro. Timeout, perda de resposta e múltiplos retries não geram duplicidade.

### Estados

| Estado    | Semântica                                                                     |
| --------- | ----------------------------------------------------------------------------- |
| `draft`   | Rascunho persistido localmente; não concorre na fila.                         |
| `pending` | Inspeção concluída e pronta para envio.                                       |
| `synced`  | Sucesso; guarda `serverId` e `syncedAt`; fica somente leitura (`isReadOnly`). |
| `failed`  | Falha com `failureReason` legível; permite reenvio.                           |

`NetworkInfo`, baseado em `connectivity_plus`, monitora a rede. Ao recuperar o sinal, chama `syncPendingQueue()` automaticamente. Também há botão de sincronização manual e ação individual **Reenviar** para itens `failed`.

As tabelas e queries usam `userId` como partição. Ao trocar de técnico no mesmo aparelho, rascunhos e filas permanecem isolados: um usuário não vaza dados nem bloqueia OSs de outro.

Fotos do `image_picker` são copiadas do cache para o diretório permanente retornado por `getApplicationDocumentsDirectory`; assim o sistema não remove a evidência antes do upload.

## Destaques implementados

### Geofence preventivo de 200 m

Na captura, o app compara o GPS do dispositivo com a coordenada cadastrada na OS. Acima de 200 m, exibe alerta visual ao técnico antes da conclusão.

### Banner de conectividade

O `OfflineBanner` reage ao estado da rede e indica no topo quando o app está offline. A coleta continua disponível enquanto a fila aguarda conexão.

### Imutabilidade da UI

Inspeções `synced` ou já encaminhadas para a fila bloqueiam edição e exibem o banner de status correspondente.

## Decisões técnicas

**SQLite com `sqflite`.** O acesso direto, com classes de tabela e `db_helper`, mantém esquema, queries da fila e partição por `userId` explícitos. Um ORM adicionaria abstração pouco necessária ao escopo e dificultaria a inspeção das transições.

**Multipart para evidências.** `multipart/form-data` envia a foto como arquivo, evitando Base64 e a duplicação do binário em uma string grande na memória.

**Falhas tipadas.** Erros de rede, API e persistência são convertidos em instâncias de `Failure`. A Presentation recebe estados previsíveis e mensagens legíveis, sem detalhes de Dio ou SQLite nos widgets.

## O que faria se tivesse mais tempo

1. Compressão dinâmica de imagem antes do salvamento permanente, respeitando qualidade e tamanho máximos.
2. Formulários dinâmicos via `GET /work-orders/:id/form-schema`, com validação orientada pelo schema.
3. Sincronização periódica em background com o app fechado, usando `workmanager` e políticas de bateria/conectividade.
4. Separação da lista de Ordens de Serviço inspecionadas e pendentes.
5. Mais testes de integração e testes de widget/página para permissões, geofence e recuperação após restart.

## Referências

- [Contrato da API mock](docs/CONTRATO_API.md)
- [Desafio e critérios de avaliação](docs/DESAFIO_CANDIDATO.md)
- [Instruções da API mock](mock-api/README.md)
