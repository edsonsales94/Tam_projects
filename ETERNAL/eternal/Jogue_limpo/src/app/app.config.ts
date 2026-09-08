import { provideRouter } from '@angular/router';

import { routes } from './app.routes';

import {
  ApplicationConfig,
  importProvidersFrom,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection,
} from '@angular/core';
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

import { PoHttpRequestModule, PoI18nConfig, PoI18nModule } from '@po-ui/ng-components';

const i18nConfig: PoI18nConfig = {
  default: {
    language: 'pt-BR',
    context: 'general',
    cache: true,
  },
  contexts: {
    general: {
      'pt-BR': {},
    },
  },
};

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideRouter(routes),
    importProvidersFrom([PoHttpRequestModule, PoI18nModule.config(i18nConfig)]),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideHttpClient(withInterceptorsFromDi()),
  ],
};
