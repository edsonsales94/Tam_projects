import { CommonModule } from '@angular/common';
import { Upload } from './componentes/upload/upload';
import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';

import { PoMenuItem, PoMenuModule, PoPageModule, PoToolbarModule } from '@po-ui/ng-components';
import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
import {
  PoCheckboxGroupOption,
  PoProgressAction,
  PoSelectOption,
  PoRadioGroupOption,
  PoUploadFileRestrictions,
  PoUploadLiterals,
  PoModalAction
} from '@po-ui/ng-components';

@Component({
  selector: 'app-root',
  imports: [CommonModule, PoToolbarModule, PoMenuModule, PoPageModule, ProtheusLibCoreModule,Upload],
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