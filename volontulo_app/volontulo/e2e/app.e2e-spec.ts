import { VolontuloPage } from './app.po';

describe('volontulo App', () => {
  let page: VolontuloPage;

  beforeEach(() => {
    page = new VolontuloPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
