# Clean Repo

Script em Bash para realizar limpar (reestabelecer caches e ignorar arquivos de config. locais) em projetos Android e ressincronizar o rastreamento do Git.

Útil após atualizar o `.gitignore` para sincronizar as mudanças com o rastreamento do gite e remover arquivos que foram versionados indevidamente, ou para resolver problemas de cache "fantasma" no Android Studio.

## Funcionalidades

Este script automatiza as seguintes tarefas de manutenção:

* **Limpeza do Gradle:** Executa `./gradlew clean` para remover builds anteriores;
* **Remoção de Lixo:** Apaga pastas `build/`, `.gradle/`, `.cxx/`, logs, arquivos temporários e caches nativos;
* **Limpeza do IDEA:** Remove caches corrompidos do Android Studio (`.idea/caches`, `workspace.xml`, etc.);
* **Refresh do Git:** Remove todos os arquivos do index (`git rm -r --cached .`) e os readiciona, garantindo que o `.gitignore` atual seja a referência;
* **Git GC:** Roda o *Garbage Collector* do Git para otimizar o repositório local.

## Pré-requisitos

* Ambiente Unix (Linux ou macOS).
* Git instalado.
* Estar na raiz de um projeto Android.
* Permissão de execução no arquivo.

## Como usar

1. **Baixe o script** para a raiz do seu projeto Android.
2. **Dê permissão de execução** (necessário apenas no primeiro uso):

```bash
chmod +x clean-repo.sh
