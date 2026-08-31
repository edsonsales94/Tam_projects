import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';

import { PoMenuItem, PoMenuModule, PoPageModule, PoToolbarModule } from '@po-ui/ng-components';
import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';

@Component({
  selector: 'app-root',
  imports: [CommonModule, PoToolbarModule, PoMenuModule, PoPageModule, ProtheusLibCoreModule],
  templateUrl: './app.html',
  styleUrls: ['./app.css'],
})

export class App {

  readonly menus: Array<PoMenuItem> = [
    {
      label: 'Cadastro do Grupo',
      action: this.onClick.bind(this),
      icon: 'an an-clipboard',
      shortLabel: 'Cadastro'
    },
    {
      label: 'Ajuda (Help)',
      action: this.onClick.bind(this),
       icon: 'an an-question',
      shortLabel: 'Ajuda'
    },
    {
      label: 'Sair',
      action: this.onClick.bind(this),
      icon: 'an an-sign-out',
      shortLabel: 'Sair'
    }
  ];

  private onClick() {
    alert('Clicked in menu item');
  }

}