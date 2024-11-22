

#### Список PRов:

- https://github.com/MysticalFaceLesS/Foundation-19/pulls/#####
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## Outfits

ID мода: CELADON_OUTFITS
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Этот мод добавляет различные наборы одежды.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- ADD: `code\game\jobs\job\security.dm`:
        `access = list`:
        Добавлено: `ACCESS_SECURITY_LVL3`

- EDIT: `code\datums\outfits\jobs\mtf.dm`:
        `/decl/hierarchy/outfit/mtf/epsilon_11/agent`,
        `/decl/hierarchy/outfit/mtf/epsilon_11/breacher`,
        `/decl/hierarchy/outfit/mtf/epsilon_11/leader`
        Изменены: `suit`, `head`

<!-- - EDIT: `code\datums\outfits\jobs\engineering.dm`:
        `/decl/hierarchy/outfit/job/engineering/seneng`
        Изменено: `id_type`
- ADD: `code\datums\outfits\jobs\engineering.dm`:
        `/decl/hierarchy/outfit/job/engineering/seneng`
        Добавлено: `r_ear`
-->
- ADD: `code\datums\outfits\jobs\security.dm`
        ADDED: `/decl/hierarchy/outfit/job/security/ez_senmedic`
        ADDED: `/decl/hierarchy/outfit/job/security/lcz_senmedic`
        ADDED: `/decl/hierarchy/outfit/job/security/hcz_senmedic`
        ADDED: `/decl/hierarchy/outfit/job/security/hcz_medic`

- ADD: `code\game\jobs\job\engineering.dm`
        ADDED: `alt_titles`

- EDIT: `code\datums\outfits\jobs\engineering.dm`:
        `/decl/hierarchy/outfit/job/engineering/conteng`
        EDITED: `id_type`, `l_ear`

- EDIT: `code\datums\outfits\jobs\security.dm`
        `/decl/hierarchy/outfit/job/security/ez_medic`
        EDITED: `id_type`, `glasses`

- EDIT: `code\datums\outfits\jobs\security.dm`
        `/decl/hierarchy/outfit/job/security/ez_guard`
        EDITED: `id_type`

- EDIT: `code\datums\outfits\jobs\security.dm`
        `/decl/hierarchy/outfit/job/security/raisa_agent`
        EDITED: `belt`
- EDIT: `code\datums\outfits\jobs\security.dm`
        `/decl/hierarchy/outfit/job/security/ez_guard_investigative`
        EDITED: `id_type`

- EDIT `code\game\jobs\job\security.dm`
        `/datum/job/raisa`
        EDITED: `min_skills`, `max_skills`

<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- Отсутствуют
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- Отсутствуют
<!--
  Если требовалось добавить какие-либо дефайны, укажи файлы,
  в которые ты их добавил, а также перечисли имена.
  И то же самое, если ты используешь дефайны, определённые другим модом.

  Не используешь - напиши "Отсутствуют"
-->

### Используемые файлы, не содержащиеся в модпаке

- Отсутствуют
<!--
  Будь то немодульный файл или модульный файл, который не содержится в папке,
  принадлежащей этому конкретному моду, он должен быть упомянут здесь.
  Хорошими примерами являются иконки или звуки, которые используются одновременно
  несколькими модулями, или что-либо подобное.
-->

### Авторы:

Voiko / John Chiffir
<!--
  Здесь находится твой никнейм
  Если работал совместно - никнеймы тех, кто помогал.
  В случае порта чего-либо должна быть ссылка на источник.
-->
