// Command repricer — точка входа сервиса Poncho Repricer.
// Сейчас это скелет: загрузка конфигурации через переиспользуемый загрузчик
// poncho-ai (pkg/config) и диагностический вывод. Бизнес-логика репрайсера
// появляется в последующих задачах — см. AGENTS.md.
package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/ilkoid/poncho-ai/pkg/config"
)

// version — версия сборки; обновляется при релизах.
const version = "0.1.0-dev"

// Config — конфигурация сервиса. Секреты здесь не хранятся: значения вида
// ${VAR} подставляются из .env при загрузке (pkg/config).
type Config struct {
	Storage struct {
		// PGDatabase — имя базы PostgreSQL; для разработки — *_test.
		PGDatabase string `yaml:"pg_database"`
	} `yaml:"storage"`
	WB struct {
		// APIKeyEnv — имя переменной окружения с ключом WB API.
		APIKeyEnv string `yaml:"api_key_env"`
	} `yaml:"wb"`
}

func main() {
	configPath := flag.String("config", "config.yaml", "путь до config.yaml")
	showVersion := flag.Bool("version", false, "вывести версию и выйти")
	flag.Parse()

	if *showVersion {
		fmt.Println("poncho-repricer", version)
		return
	}

	var cfg Config
	if err := config.LoadYAML(*configPath, &cfg); err != nil {
		log.Fatalf("загрузка конфигурации: %v", err)
	}

	fmt.Printf("poncho-repricer %s\n", version)
	fmt.Printf("  база данных : %s\n", cfg.Storage.PGDatabase)
	fmt.Printf("  ключ WB API : ${%s} (значение не выводится)\n", cfg.WB.APIKeyEnv)
	fmt.Println("скелет сервиса: бизнес-логика — в последующих задачах (AGENTS.md)")
}
