workspace {
    name "Сайт заказа услуг"
    description "Приложение для управления услугами, пользователями и заказами"

    # включаем режим с иерархической системой идентификаторов
    !identifiers hierarchical

    # Модель архитектуры
    model {

        # Настраиваем возможность создания вложенных групп
        properties { 
            structurizr.groupSeparator "/"
        }

        # Описание компонентов модели
        user = person "Пользователь"
        service_order_site = softwareSystem "Сайт заказа услуг" {
            description "Сервер управления заказами услуг"

            user_service = container "User Service" {
                description "Сервис управления пользователями"
            }

            service_service = container "Service Service" {
                description "Сервис управления услугами"
            }

            order_service = container "Order Service" {
                description "Сервис управления заказами"
            }

            group "Слой данных" {
                user_database = container "User Database" {
                    description "База данных пользователей"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                service_database = container "Service Database" {
                    description "База данных услуг"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                order_database = container "Order Database" {
                    description "База данных заказов"
                    technology "PostgreSQL 15"
                    tags "database"
                }
            }

            user_service -> user_database "Получение/обновление данных о пользователях" 
            service_service -> service_database "Получение/обновление данных об услугах" 
            order_service -> order_database "Получение/обновление данных о заказах" 
            order_service -> service_service "Получение данных об услугах"

            user -> user_service "Создание нового пользователя"
            user -> user_service "Поиск пользователя по логину"
            user -> user_service "Поиск пользователя по имени и фамилии"
            user -> service_service "Создание услуги"
            user -> service_service "Получение списка услуг"
            user -> order_service "Добавление услуги в заказ"
            user -> order_service "Получение заказа для пользователя"
        }

        user -> service_order_site "Взаимодействие с сайтом заказа услуг"

        deploymentEnvironment "Production" {
            deploymentNode "User Server" {
                containerInstance service_order_site.user_service
            }

            deploymentNode "Service Server" {
                containerInstance service_order_site.service_service
                properties {
                    "cpu" "4"
                    "ram" "256Gb"
                    "hdd" "4Tb"
                }
            }

            deploymentNode "Order Server" {
                containerInstance service_order_site.order_service
                properties {
                    "cpu" "4"
                    "ram" "256Gb"
                    "hdd" "4Tb"
                }
            }

            deploymentNode "databases" {
                deploymentNode "Database Server 1" {
                    containerInstance service_order_site.user_database
                }

                deploymentNode "Database Server 2" {
                    containerInstance service_order_site.service_database
                }

                deploymentNode "Database Server 3" {
                    containerInstance service_order_site.order_database
                    instances 3
                }
            }
        }
    }

    views {
        themes default

        properties { 
            structurizr.tooltips true
        }

        !script groovy {
            workspace.views.createDefaultViews()
            workspace.views.views.findAll { it instanceof com.structurizr.view.ModelView }.each { it.enableAutomaticLayout() }
        }

        dynamic service_order_site "UC01" "Создание нового пользователя" {
            autoLayout
            user -> service_order_site.user_service "Создать нового пользователя (POST /user)"
            service_order_site.user_service -> service_order_site.user_database "Сохранить данные о пользователе" 
        }

        dynamic service_order_site "UC02" "Поиск пользователя по логину" {
            autoLayout
            user -> service_order_site.user_service "Поиск пользователя по логину (GET /user/{login})"
            service_order_site.user_service -> service_order_site.user_database "Получить данные о пользователе" 
        }

        dynamic service_order_site "UC03" "Поиск пользователя по маске имя и фамилии" {
            autoLayout
            user -> service_order_site.user_service "Поиск пользователя по имени и фамилии (GET /user?firstName&lastName)"
            service_order_site.user_service -> service_order_site.user_database "Получить данные о пользователе" 
        }

        dynamic service_order_site "UC04" "Создание услуги" {
            autoLayout
            user -> service_order_site.service_service "Создать новую услугу (POST /service)"
            service_order_site.service_service -> service_order_site.service_database "Сохранить данные об услуге" 
        }

        dynamic service_order_site "UC05" "Получение списка услуг" {
            autoLayout
            user -> service_order_site.service_service "Получить список услуг (GET /services)"
            service_order_site.service_service -> service_order_site.service_database "Получить данные об услугах" 
        }

        dynamic service_order_site "UC06" "Добавление услуги в заказ" {
            autoLayout
            user -> service_order_site.order_service "Добавить услугу в заказ (POST /order/{orderId}/service)"
            service_order_site.order_service -> service_order_site.order_database "Сохранить данные о заказе" 
            service_order_site.order_service -> service_order_site.service_service "Получить данные об услуге"
        }

        dynamic service_order_site "UC07" "Получение заказа для пользователя" {
            autoLayout
            user -> service_order_site.order_service "Получить заказ для пользователя (GET /order/{userId})"
            service_order_site.order_service -> service_order_site.order_database "Получить данные о заказе" 
        }

        styles {
            element "database" {
                shape cylinder
            }
        }
    }
}