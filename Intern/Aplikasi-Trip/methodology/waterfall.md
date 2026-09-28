# Development Methodology - Waterfall

> ⚪ **ARSIP RANCANGAN AWAL** — dokumen ini ditulis sebelum stack final dipilih.
> Metodologi Waterfall 14 minggu — tetap berlaku sebagai acuan penulisan laporan.
> **Jangan jadikan acuan teknis** — lihat `Aplikasi-Trip/requirements/functional.md`
> untuk stack & perilaku nyata. Penanda ditambahkan 25 Sep 2026.

## Timeline: 14 Minggu (1 Semester)

### Fase 1: Requirements Gathering (2 minggu)
- Analisis kebutuhan fungsional
- Wawancara stakeholder
- Dokumentasi requirements
- Pembuatan Use Case Diagram
- Pembuatan ERD
- Pembuatan DFD

### Fase 2: Design (2 minggu)
- Desain database
- Desain API
- Desain UI/UX
- Wireframing

### Fase 3: Implementation (6 minggu)
- Setup development environment
- Backend development
- Mobile app development
- Web dashboard development
- Integration testing

### Fase 4: Testing (2 minggu)
- Unit testing
- Integration testing
- UAT (User Acceptance Testing)
- Bug fixing

### Fase 5: Deployment (2 minggu)
- Server setup
- Production deployment
- User training
- Documentation

## Roles

| Role | Responsibilities |
|------|-----------------|
| Project Manager | Timeline, resource management |
| System Analyst | Requirements, design |
| Backend Developer | API, database, Firebase |
| Mobile Developer | Flutter app |
| Web Developer | Dashboard |
| QA Engineer | Testing |

## Version Control

```
main (production)
  |
  +-- develop (integration)
       |
       +-- feature/login
       +-- feature/trip-creation
       +-- feature/offline-sync
```
