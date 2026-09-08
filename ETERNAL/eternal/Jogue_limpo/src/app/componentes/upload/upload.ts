import { Component } from '@angular/core';
import { PoFieldModule, PoUploadFileRestrictions } from '@po-ui/ng-components';

@Component({
  selector: 'app-upload',
  imports: [PoFieldModule],
  templateUrl: './upload.html',
  styleUrl: './upload.css',
})
export class Upload {
  readonly restrictions: PoUploadFileRestrictions = {
    allowedExtensions: ['.csv', '.xls', '.xlsx'],
    maxFileSize: 10 * 1024 * 1024,
    maxFiles: 1,
  };
}
