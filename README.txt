ERP ZINHO V4 — ERP DE GESTÃO INTEGRADA
=========================================

OBJETIVO
Sistema local para almoxarifado/estoque e gestão integrada, com menus laterais e dados persistidos em estoque.json.

MÓDULOS
1. Dashboard
   - Indicadores de produtos, clientes, fornecedores, estoque, compras e vendas.
   - Alertas de estoque baixo.
   - Fluxo financeiro.
   - Atalhos operacionais.

2. Cadastros
   - Produtos / Estoque.
   - Categorias.
   - Unidades.
   - Clientes.
   - Fornecedores.
   - Funcionários.
   - Produtos possuem campos para tipo (EPI, uniforme, ferramenta etc.), CA, tamanho, cor, validade e localização.

3. Operações
   - Compras com vários itens.
   - Vendas com vários itens.
   - Entradas e saídas manuais.
   - Inventário físico com cálculo automático de diferenças.
   - Compra aumenta estoque.
   - Venda reduz estoque e bloqueia quantidade acima do saldo.
   - Edição/exclusão recompõe estoque.
   - Operações canceladas não movimentam estoque.

4. Financeiro
   - Contas a pagar e receber.
   - Lançamentos manuais.
   - Parcelamento de 1 a 60 vezes.
   - Vencimentos.
   - Status Pendente/Pago/Cancelado.
   - Formas de pagamento.
   - Contas/caixa.
   - Centros de custo.
   - Dashboard de realizado e em aberto.

5. Administração
   - Relatórios.
   - Usuários e perfis.
   - Auditoria das operações.
   - Exportação CSV.

6. Sistema
   - Backup JSON completo.
   - Restauração de backup JSON.
   - Banco local.

COMO INICIAR NO WINDOWS
1. Extraia o ZIP.
2. Abra a pasta CONTROLE_ERP_ZINHO_V4.
3. Execute INICIAR_ESTOQUE.bat.
4. O navegador abrirá em http://127.0.0.1:8765.
5. Mantenha a janela do PowerShell aberta durante o uso.

DADOS
- Banco: estoque.json
- Não apague o arquivo enquanto o sistema estiver em uso.
- Faça backups regularmente.

IMPORTAÇÃO/EXPORTAÇÃO
Cada módulo possui Exportar modelo e Importar CSV.
Os arquivos podem ser editados no Excel e importados novamente.

OBSERVAÇÃO DE ARQUITETURA
Esta versão é local/offline, adequada para uso em um computador ou rede controlada. Ela não implementa autenticação de servidor real nem emissão fiscal/NF-e. Para uma implantação multiusuário em produção, a próxima camada deve usar banco SQL, autenticação, API, permissões no servidor, logs imutáveis e rotinas de backup automatizadas.
