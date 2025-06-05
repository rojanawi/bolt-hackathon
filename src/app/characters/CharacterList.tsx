interface Character {
  id: string;
  name: string;
  health: number;
  attack: number;
  defense: number;
}

export default function CharacterList({ characters }: { characters: Character[] }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {characters.map((character) => (
        <div key={character.id} className="bg-gray-800 p-6 rounded-lg">
          <h3 className="text-xl font-semibold mb-2">{character.name}</h3>
          <div className="space-y-2">
            <div className="flex justify-between">
              <span>Health:</span>
              <span>{character.health}</span>
            </div>
            <div className="flex justify-between">
              <span>Attack:</span>
              <span>{character.attack}</span>
            </div>
            <div className="flex justify-between">
              <span>Defense:</span>
              <span>{character.defense}</span>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}